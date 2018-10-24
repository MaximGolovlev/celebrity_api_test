//
//  Date+Helpers.swift
//  CelebEthnicity
//
//  Created by User on 22.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: String) -> String {
        
        let formatter = DateFormatter(withFormat: format, locale: "en")
        let string = formatter.string(from: self)
        return string
    }
}
