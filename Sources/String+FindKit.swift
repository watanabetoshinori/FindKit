//
//  String+FindKit.swift
//  FindKit
//
//  Created by Watanabe Toshinori on 12/5/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit

extension String {
    
    ///
    /// Get all ranges which matched with specified query.
    ///
    func ranges(of query: String) -> [Range<String.Index>] {
        var ranges = [Range<String.Index>]()
        
        while let range = self.range(of: query, options: .caseInsensitive, range: (ranges.last?.upperBound ?? startIndex)..<endIndex, locale: nil) {
            ranges.append(range)
        }
        
        return ranges
    }
    
    ///
    /// Get styled attribute strings based on specified range.
    ///
    func styledStringAround(of range: Range<String.Index>) -> NSAttributedString {
        // Get arround text of matched range
        let lastNewLineIndex = self.range(of: "\n", options: .backwards, range: startIndex..<range.lowerBound)?.upperBound ?? startIndex
        let nextNewLineIndex = self.range(of: "\n", options: [], range: range.upperBound..<endIndex)?.lowerBound ?? endIndex
        let matchedBlock = String(self[lastNewLineIndex..<nextNewLineIndex])
        let attributedString = NSMutableAttributedString(string: matchedBlock)
        
        // Highlighting matched range
        let start = distance(from: lastNewLineIndex, to: range.lowerBound)
        let end = distance(from: range.upperBound, to: nextNewLineIndex)
        let styledRange = NSRange(location: start, length: matchedBlock.count - (start + end))
        attributedString.addAttributes([.backgroundColor: UIColor(red: 225/255, green: 220/255, blue: 140/255, alpha: 0.7)], range: styledRange)
        
        // Replacing new line code to symbol
        let mutableString = attributedString.mutableString
        while mutableString.contains("\n") {
            let r = mutableString.range(of: "\n")
            mutableString.replaceCharacters(in: r, with: "↩︎")
        }
        
        // Trimming spaces
        let charSet = CharacterSet.whitespaces
        var range = mutableString.rangeOfCharacter(from: charSet)
        while range.lowerBound == 0 {
            mutableString.replaceCharacters(in: range, with: "")
            range = mutableString.rangeOfCharacter(from: charSet)
        }
        range = mutableString.rangeOfCharacter(from: charSet, options: .backwards)
        while range.upperBound == mutableString.length {
            mutableString.replaceCharacters(in: range, with: "")
            range = mutableString.rangeOfCharacter(from: charSet, options: .backwards)
        }

        return attributedString
    }
    
}
