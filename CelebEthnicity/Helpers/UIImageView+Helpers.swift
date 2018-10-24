//
//  UIImageView+Helpers.swift
//  CelebEthnicity
//
//  Created by User on 22.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImage(_ stringUrl: String?, placeHolder: UIImage?, completion: ((UIImage?) -> ())?) {
        
        let loadingView = UIActivityIndicatorView(style: .whiteLarge)
        loadingView.hidesWhenStopped = true
        
        self.addSubview(loadingView)
        loadingView.centerInSuperview()
        loadingView.startAnimating()
    
        self.image = placeHolder
        
        guard let string = stringUrl, let url = URL(string: string) else { completion?(nil); return }
        
        if let image = imageCache.object(forKey: string as NSString) {
            self.subviews.map({ $0 as? UIActivityIndicatorView }).first??.stopAnimating()
            self.image = image
            completion?(image)
            return
        }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 5
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { (data, _, error) in
            
            DispatchQueue.main.async {
                
                 self.subviews.map({ $0 as? UIActivityIndicatorView }).first??.stopAnimating()
                
                guard let data = data else {
                    completion?(nil)
                    return
                }
                
                let image = UIImage(data: data)
                
                if let image = image {
                    self.image = image
                    imageCache.setObject(image, forKey: string as NSString)
                }
                
                completion?(image)
            }
            
        }.resume()
    
    }
    
}

