//
//  FKMatches.swift
//  FindKit
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

public class FKMatch: NSObject {
    
    /// Matching strings.
    public var string: String!
    
    /// Range of matching strings.
    public var range: Range<String.Index>!
    
    /// Several lines of strings including highlighted matching strings.
    public var styledString: NSAttributedString!
    
    // MARK: - Initializing FKMatch

    public convenience init(string: String, range: Range<String.Index>, styledString: NSAttributedString) {
        self.init()
        self.string = string
        self.range = range
        self.styledString = styledString
    }

}
