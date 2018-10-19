//
//  UIAlertView+Helpers.swift
//  CelebEthnicity
//
//  Created by User on 18.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static public func showAlert(_ message: String, _ controller: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
