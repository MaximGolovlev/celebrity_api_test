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
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var textContainer: UIView!
    
    @IBOutlet weak var birthNameTitle: UILabel!
    @IBOutlet weak var placeOfBirthTitle: UILabel!
    @IBOutlet weak var dateOfBirthTitle: UILabel!
    @IBOutlet weak var ethnicityTitle: UILabel!
    
    @IBOutlet weak var birthNameDetail: ResizableTextView!
    @IBOutlet weak var heightDetail: ResizableTextView!
    @IBOutlet weak var placeOfBirthDetail: ResizableTextView!
    @IBOutlet weak var dateOfBirthDetail: ResizableTextView!
    @IBOutlet weak var dateOfDeathDetail: ResizableTextView!
    @IBOutlet weak var placeOfDeathDetail: ResizableTextView!
    @IBOutlet weak var ethnicityDetail: ResizableTextView!
    @IBOutlet weak var descriptionDetail: ResizableTextView!
    @IBOutlet weak var similarDetail: ResizableTextView!
    @IBOutlet weak var tagsDetail: ResizableTextView!
    
    @IBOutlet weak var birthNameContainer: UIStackView!
    @IBOutlet weak var heightContainer: UIStackView!
    @IBOutlet weak var placeOfBirthContainer: UIStackView!
    @IBOutlet weak var dateOfBirthContainer: UIStackView!
    @IBOutlet weak var dateOfDeathContainer: UIStackView!
    @IBOutlet weak var placeOfDeathContainer: UIStackView!
    @IBOutlet weak var ethnicityContainer: UIStackView!
    @IBOutlet weak var descriptionContainer: UIStackView!
    @IBOutlet weak var similarContainer: UIStackView!
    @IBOutlet weak var tagsContainer: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var celebrity: Celebrity?
    var imageViewHeroId: String?
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGesture.delegate = self
        
        setup(heroId: imageViewHeroId, celebrity: celebrity)
    }
    
    func setup(heroId: String?, celebrity: Celebrity?) {
        
        if let id = imageViewHeroId, let celeb = celebrity {
            avatarImageView.hero.id = id
            textContainer.hero.modifiers = [.source(heroID: id), .fade]
            
            renderInfo(celeb: celeb)
        }
    }
    
    func renderInfo(celeb: Celebrity?) {
        
        avatarImageView.loadImage(celeb?.picture, placeHolder: #imageLiteral(resourceName: "image_placeholder"), completion: nil)
        
        mainTitleLabel.text = celeb?.name
        dateLabel.text = celeb?.lastUpdate?.dateValue().toString(format: "dd MMMM yyyy")
        
        if let birthName = celeb?.birthName, !birthName.isEmpty {
            birthNameContainer.isHidden = false
            birthNameDetail.text = birthName
        }
        
        if let height = celeb?.height?.height, !height.isEmpty {
            heightContainer.isHidden = false
            heightDetail.text = height
        }
        
        if let birthPlace = celeb?.birthPlace, !birthPlace.isEmpty {
            placeOfBirthContainer.isHidden = false
            placeOfBirthDetail.text = birthPlace
        }
        
        if let dateOfBirth = celeb?.dateOfBith, !dateOfBirth.isEmpty {
            dateOfBirthContainer.isHidden = false
            dateOfBirthDetail.text = dateOfBirth
        }
        
        if let deathPlace = celeb?.deathPlace, !deathPlace.isEmpty {
            placeOfDeathContainer.isHidden = false
            placeOfDeathDetail.text = deathPlace
        }
        
        if let dateOfDeath = celeb?.dateOfDeath, !dateOfDeath.isEmpty {
            dateOfDeathContainer.isHidden = false
            dateOfDeathDetail.text = dateOfDeath
        }
        
        if celeb?.ethnicity?.isEmpty != true {
            ethnicityContainer.isHidden = false
            ethnicityDetail.text = celeb?.ethnicity?.compactMap({ $0.name }).joined(separator: "\n")
        }
        
        if let descr = celeb?.description, !descr.isEmpty {
            descriptionContainer.isHidden = false
            descriptionDetail.text = descr.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if celeb?.similar?.isEmpty != true {
            similarContainer.isHidden = false
            similarDetail.text = celeb?.similar?.joined(separator: "\n")
        }
        
        if let tags = celeb?.tags, !tags.isEmpty {
            tagsContainer.isHidden = false
            tagsDetail.text = tags.joined(separator: ", ")
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
        let offest = scrollView.contentOffset
        
        let v = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: nil)
        return v.y > abs(v.x) && offest.y <= 0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}



