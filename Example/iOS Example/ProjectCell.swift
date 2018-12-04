//
//  ProjectCell.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Configure
    
    func configure(with project: Project) {
        nameLabel.text = project.index.name
        
        if project.isLoaded {
            accessoryType = .disclosureIndicator
            selectionStyle = .default
        } else {
            accessoryType = .none
            selectionStyle = .none
        }
    }

}
