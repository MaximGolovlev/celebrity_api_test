//
//  String+Helpres.swift
//  CelebEthnicity
//
//  Created by User on 19.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

extension String {
    var html2AttributedString: NSMutableAttributedString? {
        do {
            let string = try NSMutableAttributedString(
                data: (self.data(using: String.Encoding.unicode, allowLossyConversion: true)!),
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            
            return string
        } catch {
            print(error)
            return nil
        }
    }
}

extension String {
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
}
