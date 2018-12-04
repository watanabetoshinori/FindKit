//
//  Project.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import Zip
import FindKit

class Project: NSObject {
        
    var index: FKIndex!

    var url: URL!
    
    var zipFileURL: URL {
        let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileURL = cachesDirectoryURL.appendingPathComponent(index.name + ".zip")
        return fileURL
    }
    
    var rootURL: URL {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let rootURL = documentDirectoryURL.appendingPathComponent(index.name)
        return rootURL
    }
    
    var isLoaded: Bool {
        if FileManager.default.fileExists(atPath: rootURL.path) == false {
            return false
        }
        
        if index.count() == 0 {
            return false
        }
        
        return true
    }
    
    // MARK: - Initializing Project
    
    convenience init(name: String, url: URL) {
        self.init()
        self.index = FKIndex(name: name)
        self.url = url
    }
    
    // MARK: - Download, Unzip and Indexing Project
    
    func download(completionHandler: @escaping (Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                return
            }
            
            do {
                try data?.write(to: self.zipFileURL)
                
                self.unzip(self.zipFileURL, completionHandler: completionHandler)
                
            } catch {
                DispatchQueue.main.async {
                    completionHandler(error)
                }
            }
        }
        
        task.resume()
    }
    
    private func unzip(_ fileURL: URL, completionHandler: @escaping (Error?) -> Void) {
        do {
            try Zip.unzipFile(fileURL, destination: rootURL, overwrite: true, password: nil)
            
            self.createIndexes(completionHandler: completionHandler)
            
        } catch {
            DispatchQueue.main.async {
                completionHandler(error)
            }
        }
    }
    
    private func createIndexes(completionHandler: @escaping (Error?) -> Void) {
        // Getting total number of files
        var total = 0
        var enumrator = FileManager.default.enumerator(at: rootURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        enumrator?.forEach({ (object) in
            total += 1
        })
        
        if total == 0 {
            let error = NSError(domain: "Sample", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load files."])
            completionHandler(error)
            return
        }
        
        // Generate index for each file
        var completed = 0
        enumrator = FileManager.default.enumerator(at: rootURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        enumrator?.forEach({ (object) in
            DispatchQueue.global().async {
                // Create index of iOS source files
                if let url = object as? URL, ["swift", "h", "m"].contains(url.pathExtension) {
                    let relativePath = url.standardizedFileURL.relativePath.replacingOccurrences(of: NSHomeDirectory(), with: "")
                    
                    let document = FKDocument.create(from: relativePath)
                    
                    let _ = self.index.add(document: document)
                }
                
                // Update pgoress
                DispatchQueue.main.async {
                    completed += 1
                    
                    if completed == total {
                        completionHandler(nil)
                    }
                }
            }
        })
    }
    
}
