//
//  FindViewController.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import FindKit

enum FindViewControllerState {
    case input(String)
    case search(String)
}

class FindViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, DocumentCellDelegate {

    @IBOutlet weak var bottomButtonItem: UIBarButtonItem!
    
    var index: FKIndex!
    
    var documents: [FKDocument]? {
        didSet {
            updateTableViewBackground()
            updateResultLabel()
        }
    }
    
    var state: FindViewControllerState = .input("") {
        didSet {
            switch state {
            case .input:
                documents?.removeAll()
                tableView.reloadData()
                
            case .search(let query):
                searchIndexes(with: query)
            }
        }
    }
    
    var detailState = [String /* FKDocument.relativePath */: Bool /* Show Details */]()
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateResultLabel()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.destination, segue.identifier) {
        case (let viewController as SourceViewController, "ShowSourceViewController"?):
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            guard let document = documents?[indexPath.section],
                let match = document.matches?[indexPath.row - 1] else {
                return
            }
            
            viewController.document = document
            viewController.match = match
            
        default:
            break
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch state {
        case .input:
            return 1
            
        case .search:
            return documents?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .input(let query):
            if query.isEmpty {
                return 0
            }
            return 1 /* Search Query */
            
        case .search:
            guard let document = documents?[section] else {
                return 0
            }
            
            if isDetailShown(for: document) {
                return (document.matches?.count ?? 0) + 1 /* Document */
            } else {
                return 1 /* Document */
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .input(let query):
            // Search Query
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchQueryCell", for: indexPath)
            cell.textLabel?.text = "Search for \"\(query)\""
            return cell
            
        case .search:
            guard let document = documents?[indexPath.section] else {
                return UITableViewCell()
            }
            
            if indexPath.row == 0 {
                // Document
                let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
                cell.configure(document, isDetailShown: isDetailShown(for: document))
                cell.delegate = self
                return cell
                
            } else {
                guard let match = document.matches?[indexPath.row - 1] else {
                    return UITableViewCell()
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as! MatchCell
                cell.configure(match)
                return cell
            }
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch state {
        case .input(let query):
            if indexPath.row == 0 {
                state = .search(query)
            }
            
        case .search:
            break
        }
    }
    
    // MARK: - Document Cell delegate
    
    func documentCellDetailTapped(_ cell: DocumentCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        guard let document = documents?[indexPath.section] else {
            return
        }
        
        // Show / Hide Details
        if let bool = detailState[document.relativePath] {
            detailState[document.relativePath] = !bool
        } else {
            detailState[document.relativePath] = false
        }
        
        tableView.reloadSections([indexPath.section], with: .automatic)
    }
    
    // MARK: - Search result updating
    
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        state = .input(query)
    }
    
    // MARK: - Search bar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text ?? ""
        state = .search(query)
    }
    
    // MARK: - Update Controls
    
    func initializeSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Text"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateTableViewBackground() {
        tableView.backgroundView = nil
        
        switch state {
        case .input:
            break
            
        case .search(let query):
            if documents == nil || documents?.isEmpty == true {
                let label = UILabel(frame: CGRect(origin: .zero, size: tableView.bounds.size))
                label.text = "No Results for \"\(query)\""
                label.textAlignment = .center
                tableView.backgroundView = label
            }
        }
    }
    
    func updateResultLabel() {
        navigationController?.isToolbarHidden = true

        switch state {
        case .input:
            break
            
        case .search:
            let files = documents?.count ?? 0
            let results = documents?.reduce(into: 0, { $0 += $1.matches?.count ?? 0 }) ?? 0
            
            navigationController?.isToolbarHidden = false
            
            let resultLabel = UILabel(frame: .zero)
            resultLabel.font = UIFont.systemFont(ofSize: 12)
            resultLabel.text = "\(results) results in \(files) files"
            
            bottomButtonItem.customView = resultLabel
        }
    }
    
    // MARK: - Search indexes
    
    func searchIndexes(with query: String) {
        // Hide keyboard
        navigationItem.searchController?.searchBar.resignFirstResponder()

        // Execute search query
        let search = FKSearch(query: query)
        
        index.findMatches(with: search) { (documents) in
            self.detailState.removeAll()
            self.documents = documents
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Detail State for Document
    
    func isDetailShown(for document: FKDocument) -> Bool {
        if let bool = detailState[document.relativePath], bool == false {
            return false
        }
        
        return true
    }

}
