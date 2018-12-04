//
//  FKDocument.swift
//  FindKit
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public class FKDocument: NSObject {
    
    /// Relative path for document. (e.g. /Documents/Project/Souce.swift)
    public var relativePath: String!

    /// Content of document.
    public var text: String!

    /// Finded matches of document. This property will be set by FKIndex#findMatches function.
    public var matches: [FKMatch]?
    
    /// File name of document.
    public var fileName: String {
        return (relativePath as NSString).lastPathComponent
    }

    // MARK: - Initializing FKDocument
    
    convenience init(relativePath: String, text: String) {
        self.init()
        self.relativePath = relativePath
        self.text = text
    }
    
    // MARK: - Create Instance from RelativePath
    
    public class func create(from relativePath: String) -> FKDocument {
        // Load content of document
        let homeDirectoryURL = URL(fileURLWithPath: NSHomeDirectory())
        let url = homeDirectoryURL.appendingPathComponent(relativePath)
        
        var content = ""
        do {
            content = try String(contentsOf: url)
        } catch {
            print(error)
        }

        return FKDocument(relativePath: relativePath, text: content)
    }

}
