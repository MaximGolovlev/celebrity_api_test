//
//  HTMLParcingManager.swift
//  CelebEthnicity
//
//  Created by User on 18.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftSoup

class HTMLParcingManager {
    
    typealias Item = (text: String, html: String)
    private (set) var rootViewController: UIViewController
    private (set) var document: Document = Document.init("")

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func downloadHTML(urlString: String?) -> String? {
        // url string to URL
        guard let url = URL(string: urlString ?? "") else {
            // an error occurred
            UIAlertController.showAlert("Error: \(urlString ?? "") doesn't seem to be a valid URL", self.rootViewController)
            return nil
        }
        
        do {
            // content of url
            let html = try String.init(contentsOf: url)
            // parse it into a Document
            document = try SwiftSoup.parse(html)
            return html
        } catch let error {
            // an error occurred
            UIAlertController.showAlert("Error: \(error)", self.rootViewController)
            return nil
        }
    }
    
    func changeHtml(_ html: String?) {
        guard let html = html else { return }
        
        do {
            document = try SwiftSoup.parse(html)
        } catch let error {
            UIAlertController.showAlert("Error: \(error)", self.rootViewController)
        }
    }
    
    //Parse CSS selector
    func parse(cssQuery: String?) -> [Item]? {
        do {
            var items = [Item]()
            // firn css selector
            let elements: Elements = try document.select(cssQuery ?? "")
            //transform it into a local object (Item)
            for element in elements {
                let text = try element.text()
                let html = try element.outerHtml()
                items.append(Item(text: text, html: html))
            }
            return items
            
        } catch let error {
            UIAlertController.showAlert("Error: \(error)", self.rootViewController)
        }
        
        return nil
    }
}
