//
//  CelebrityController.swift
//  CelebEthnicity
//
//  Created by User on 16.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit
import Hero

class CelebrityController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var textContainer: UIView!
    
    @IBOutlet weak var birthNameTitle: UILabel!
    @IBOutlet weak var placeOfBirthTitle: UILabel!
    @IBOutlet weak var dateOfBirthTitle: UILabel!
    @IBOutlet weak var ethnicityTitle: UILabel!
    
    @IBOutlet weak var birthNameDetail: ResizableTextView!
    @IBOutlet weak var placeOfBirthDetail: ResizableTextView!
    @IBOutlet weak var dateOfBirthDetail: ResizableTextView!
    @IBOutlet weak var ethnicityDetail: ResizableTextView!
    
    var imageView: UIImageView?
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = imageView?.hero.id {
            avatarImageView.hero.id = id
            avatarImageView.image = imageView?.image
            textContainer.hero.modifiers = [.source(heroID: id), .fade]
        }
    }
    @IBAction func viewTapped(_ sender: Any) {
        
        hero.dismissViewController()
    }
    
    @IBAction func tapGestureHandler(_ sender: UITapGestureRecognizer) {
        hero.dismissViewController()
    }
    
    @IBAction func panGestureHandler(_ gr: UIPanGestureRecognizer) {
        
        let translation = gr.translation(in: view)

        switch gr.state {
        case .began:
            dismiss(animated: true, completion: nil)
        case .changed:
            Hero.shared.update(translation.y / view.bounds.height)
            let imagePos = CGPoint(x: translation.x + avatarImageView.center.x, y: translation.y + avatarImageView.center.y)
            Hero.shared.apply(modifiers: [.position(imagePos)], to: avatarImageView)
            let textViewPos = CGPoint(x: translation.x + textContainer.center.x, y: translation.y + textContainer.center.y)
            Hero.shared.apply(modifiers: [.position(textViewPos)], to: textContainer)
        default:
            let velocity = gr.velocity(in: view)
            if ((translation.y + velocity.y) / view.bounds.height) > 0.5 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
    
}

extension CelebrityController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let v = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: nil)
        return v.y > abs(v.x)
    }
}


