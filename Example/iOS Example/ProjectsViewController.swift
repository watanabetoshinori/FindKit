//
//  ProjectsViewController.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProjectsViewController: UITableViewController {

    /// iOS Projects from Github
    var projects = [
        Project(name: "Alamofire", url: URL(string: "https://github.com/Alamofire/Alamofire/archive/master.zip")!),
        Project(name: "SDWebImage", url: URL(string: "https://github.com/SDWebImage/SDWebImage/archive/master.zip")!),
        Project(name: "ReactiveCocoa", url: URL(string: "https://github.com/ReactiveCocoa/ReactiveCocoa/archive/master.zip")!),
        Project(name: "Swift Algorithm Club", url: URL(string: "https://github.com/raywenderlich/swift-algorithm-club/archive/master.zip")!),
        Project(name: "SwiftyJSON", url: URL(string: "https://github.com/SwiftyJSON/SwiftyJSON/archive/master.zip")!),
    ]
    
    // MARK: - View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let project = projects[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
        cell.configure(with: project)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = projects[indexPath.row]
        
        if project.isLoaded {
            showSearchViewController(project: project)            
        } else {
            loadingProject(project)
        }
    }
    
    // MARK: - Loading Project
    
    func loadingProject(_ project: Project) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.tableView, animated: true)
            hud.label.text = "Loading..."
            hud.isSquare = true
            
            project.download { (error) in
                
                hud.hide(animated: true)
                
                if let error = error {
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                self.tableView.reloadData()
                
                self.showSearchViewController(project: project)
            }
        }
    }
    
    // MARK: - Show Search View Controller
    
    func showSearchViewController(project: Project) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "FindViewController") as! FindViewController
        viewController.index = project.index
        navigationController?.pushViewController(viewController, animated: true)
    }

}
