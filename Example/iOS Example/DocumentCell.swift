//
//  DocumentCell.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import FindKit

protocol DocumentCellDelegate: class {
    func documentCellDetailTapped(_ cell: DocumentCell)
}

class DocumentCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var fileNamelabel: UILabel!
    
    @IBOutlet weak var detailAccessoryButton: UIButton!
    
    weak var delegate: DocumentCellDelegate?
    
    // MARK: - Configure Cell
    
    func configure(_ document: FKDocument, isDetailShown: Bool) {
        fileNamelabel.text = document.fileName
        
        let imageName = isDetailShown ? "UITableViewCellAccessoryDetailShown" : "UITableViewCellAccessoryDetailHidden"
        detailAccessoryButton.setImage(UIImage(named: imageName), for: .normal)
        
        // Hide separator
        separatorInset = UIEdgeInsets(top: 0, left: contentView.frame.width * 2, bottom: 0, right: 0)
    }
    
    // MARK: - Actions
    
    @IBAction func detailTapped(_ sender: Any) {
        delegate?.documentCellDetailTapped(self)
    }

}
