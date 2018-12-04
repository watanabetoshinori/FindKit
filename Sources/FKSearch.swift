//
//  FKSearch.swift
//  FindKit
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public class FKSearch: NSObject {
    
    /// Text for search.
    public var query = ""
    
    /// Option for search.
    public var options: FKSearchOptions?
    
    // MARK: - Initializing FKSearch
    
    public convenience init(query: String, options: FKSearchOptions? = nil) {
        self.init()
        self.query = query
        self.options = options
    }
    
}
