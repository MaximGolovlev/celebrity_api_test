//
//  ResizableTextView.swift
//  CelebEthnicity
//
//  Created by User on 16.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit

class ResizableTextView: UITextView {
    
    var myHeightConstraint: NSLayoutConstraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if myHeightConstraint == nil {
            self.translatesAutoresizingMaskIntoConstraints = false
            myHeightConstraint = heightAnchor.constraint(equalToConstant: contentSize.height)
            myHeightConstraint?.isActive = true
        }
        
        myHeightConstraint?.constant = contentSize.height
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        
        let linkAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9725490196, green: 0.7215686275, blue: 0.2549019608, alpha: 1) ,
            NSAttributedString.Key.underlineColor : #colorLiteral(red: 0.9725490196, green: 0.7215686275, blue: 0.2549019608, alpha: 1),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        linkTextAttributes = linkAttributes
    }
    
}
