//
//  MenuController.swift
//  CelebEthnicity
//
//  Created by User on 16.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit
import Hero

class MenuController: UIViewController {
    
    var dismissed: (()->())?
    
    @IBAction func viewTapHandler(_ sender: Any) {
        hero.dismissViewController(completion: dismissed)
    }
    
    @IBAction func addHandler(_ sender: UIButton) {
        let vc = AddCelebrityController()
        vc.hero.isEnabled = true
        sender.hero.id = "selected"
        vc.contentView.backgroundColor = sender.backgroundColor
        vc.contentView.hero.modifiers = [.source(heroID: "selected")]
        
        show(vc, sender: self)
    }
    
//    override var next: UIResponder? {
//        get {
//            return nil
//        }
//    }
    
}
