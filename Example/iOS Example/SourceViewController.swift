//
//  SourceViewController.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import FindKit

class SourceViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var document: FKDocument!
    
    var match: FKMatch!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = document.fileName
        
        textView.text = document.text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Scroll to matched range
        let location = document.text.distance(from: document.text.startIndex, to: match.range.lowerBound)
        let length = document.text.distance(from: match.range.lowerBound, to: match.range.upperBound)
        let nsRange = NSMakeRange(location, length)
        textView.scrollRangeToVisible(nsRange)
    }

}
