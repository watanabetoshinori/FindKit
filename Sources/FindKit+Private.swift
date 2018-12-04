//
//  FindKit+Private.swift
//  FindKit
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import RealmSwift

class Index: Object {
    
    @objc dynamic var name = ""
    
    let documents = List<Document>()
    
    // MARK: - Object functions
    
    override static func primaryKey() -> String? {
        return "name"
    }

}

class Document: Object {
    
    @objc dynamic var relativePath = ""
    
    @objc dynamic var content = ""
    
    // MARK: - Object functions
    
    override static func primaryKey() -> String? {
        return "relativePath"
    }

}
