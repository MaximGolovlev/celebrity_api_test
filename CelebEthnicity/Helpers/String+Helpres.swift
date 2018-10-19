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
            return try NSMutableAttributedString(
                data: (self.data(using: String.Encoding.unicode, allowLossyConversion: true)!),
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
        } catch {
            print(error)
            return nil
        }
    }
}
