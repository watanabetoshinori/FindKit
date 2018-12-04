//
//  FKIndex.swift
//  FindKit
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import RealmSwift

public class FKIndex: NSObject {
    
    /// Index name
    public var name: String!

    // MARK: - Initializing FKIndex
    
    public convenience init(name: String) {
        self.init()

        self.name = name
        
        do {
            let realm = try Realm()
            
            if realm.object(ofType: Index.self, forPrimaryKey: name) == nil {
                let indexObject = Index()
                indexObject.name = name
                
                try realm.write {
                    realm.add(indexObject)
                }
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Managing documents

    ///
    /// Add a new document to Index.
    ///
    public func add(document: FKDocument, update: Bool = true) -> Bool {
        do {
            let realm = try Realm()
            
            if let indexObject = realm.object(ofType: Index.self, forPrimaryKey: name) {
                let documentObject = Document()
                documentObject.relativePath = document.relativePath
                documentObject.content = document.text
                
                try realm.write {
                    realm.add(documentObject, update: true)
                    if indexObject.documents.contains(documentObject) == false {
                        indexObject.documents.append(documentObject)
                    }
                }
                
                return true
            }
        } catch {
            print(error)
        }
        
        return false
    }
    
    ///
    /// Removing a specifed document from Index.
    ///
    public func remove(document: FKDocument) -> Bool {
        do {
            let realm = try Realm()
            
            if let documentObject = realm.object(ofType: Document.self, forPrimaryKey: document.relativePath) {
                try realm.write {
                    realm.delete(documentObject)
                }

                return true
            }

        } catch {
            print(error)
        }

        return false
    }
    
    ///
    /// Remove all documents from Index.
    ///
    public func flush() -> Bool {
        do {
            let realm = try Realm()
            
            if let indexObject = realm.object(ofType: Index.self, forPrimaryKey: name) {
                try realm.write {
                    realm.delete(indexObject.documents)
                    realm.delete(indexObject)
                }
                
                return true
            }
            
        } catch {
            print(error)
        }
        
        return false
    }
    
    ///
    /// Returns documents count of Index.
    ///
    public func count() -> Int {
        do {
            let realm = try Realm()
            
            return realm.objects(Index.self).count
            
        } catch {
            print(error)
        }
        
        return 0
    }
    
    // MARK: - Find Matches
    
    ///
    /// Find all matches from specifed search query.
    ///
    public func findMatches(with search: FKSearch, completionHandler: ([FKDocument]) -> Void) {
        do {
            let realm = try Realm()
            
            guard let indexObject = realm.object(ofType: Index.self, forPrimaryKey: name) else {
                return completionHandler([])
            }

            let limit = search.options?.limit ?? 0

            let documentObjects = indexObject.documents.filter("content CONTAINS[c] %@", search.query)

            var documents = [FKDocument]()

            for documentObject in Array(documentObjects) {
                let document = FKDocument(relativePath: documentObject.relativePath, text: documentObject.content)

                var matches = [FKMatch]()
                document.text.ranges(of: search.query).forEach({ (range) in
                    let string = String(document.text[range])
                    let styledString = document.text.styledStringAround(of: range)
                    
                    let match = FKMatch(string: string, range: range, styledString: styledString)
                    matches.append(match)
                })
                document.matches = matches
                
                documents.append(document)

                if limit != 0, documents.count > limit {
                    break
                }
            }
            
            completionHandler(documents)
            
        } catch {
            print(error)

            completionHandler([])
        }
    }
    
}
