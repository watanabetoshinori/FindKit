//
//  MatchCell.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import FindKit

class MatchCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Configure Cell
    
    func configure(_ match: FKMatch) {
        label.attributedText = match.styledString
    }

}
