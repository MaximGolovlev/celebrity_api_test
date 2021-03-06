//
//  ViewController.swift
//  CelebEthnicity
//
//  Created by User on 12.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import CollectionKit
import ViewAnimator

enum FeedViewStackItem: Int {
    case long = 1
    case combined = 2
}

class FeedController: UIViewController, BaseView {
    
    let superStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.tag = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    let longStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 5
        sv.tag = 1
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let combinedStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 5
        sv.tag = 2
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let shortStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.tag = 3
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillEqually
        return sv
    }()
    
    var imageViews = [UIImageView]()
    @IBOutlet weak var menuButton: UIButton!
    
    var imageSource = [String]()
    var dataSource = [Celebrity]()
    var firbaseManager = FirbaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // fetchCelebs()
    }
    
    func fetchCelebs() {
        firbaseManager.fetchCelebrities(limit: 7, orderedBy: nil) { [weak self] (celebs, error) in
            
            guard error == nil else {
                self?.showAlert(title: "Error", message: error?.localizedDescription)
                return
            }
            
            if let celebs = celebs {
                self?.imageSource = celebs.compactMap({ $0.picture })
                self?.dataSource = celebs
                
                self?.renderViews()
            }
        }
    }
    
    func renderViews() {
        clearScreen { [weak self] in
            self?.configureViews()
        }
        
    }
    
    func clearScreen(completion: @escaping ()->()) {
        
        let removing = {
            [self.superStackView, self.longStackView, self.combinedStackView, self.shortStackView].forEach({ stackView in
                stackView.removeFromSuperview()
                
                stackView.arrangedSubviews.forEach({ view in
                    stackView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                })
            })
            
            self.imageViews.removeAll()
        }
        
        if !imageViews.isEmpty {
            UIView.animate(views: imageViews,
                           animations: [AnimationType.zoom(scale: 0.2)],
                           reversed: true,
                           initialAlpha: 1.0,
                           finalAlpha: 0.0,
                           animationInterval: 0.01,
                           duration: 0.1,
                           completion: {
                                removing()
                                completion()
                            })
        } else {
            removing()
            completion()
        }
    }
    
    func configureViews() {

        view.insertSubview(superStackView, at: 0)
        superStackView.fillSafeArea()
        
        [longStackView, combinedStackView].shuffled().forEach { (sv) in
            
            switch sv.tag {
            case FeedViewStackItem.long.rawValue:
                let long = configureLongStackView()
                superStackView.addArrangedSubview(long)
                
            case FeedViewStackItem.combined.rawValue:
                let combined = configureCombinedStackView()
                superStackView.addArrangedSubview(combined)
                
            default: break
            }
        }
        
        combinedStackView.widthAnchor.constraint(equalTo: superStackView.widthAnchor, multiplier: 0.6).isActive = true
        
        UIView.animate(views: imageViews,
                       animations: [AnimationType.zoom(scale: 0.2)],
                       animationInterval: 0,
                       duration: 0.2,
                       completion: nil)
    }
    
    func configureLongStackView() -> UIStackView {
        
        let firstImageView  = imageView(self.imageSource.removeFirst())
        let secondImageView = imageView(self.imageSource.removeFirst())
        let thirdImageView  = imageView(self.imageSource.removeFirst())
        
        [firstImageView, secondImageView, thirdImageView].forEach { (iv) in
            longStackView.addArrangedSubview(iv)
        }
        
        thirdImageView.translatesAutoresizingMaskIntoConstraints = false
        thirdImageView.heightAnchor.constraint(equalTo: longStackView.heightAnchor, multiplier: 0.5).isActive = true

        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        secondImageView.translatesAutoresizingMaskIntoConstraints = false
        secondImageView.heightAnchor.constraint(equalTo: firstImageView.heightAnchor, multiplier: 1.5).isActive = true
        
        return longStackView
    }
    
    func configureCombinedStackView() -> UIStackView {
        
        let short = configurateShortStackView()
        let firstImageView  = imageView(self.imageSource.removeFirst())
        let secondImageView = imageView(self.imageSource.removeFirst())
        
        [short, firstImageView, secondImageView].shuffled().forEach { (view) in
            combinedStackView.addArrangedSubview(view)
        }
        
        
        firstImageView.translatesAutoresizingMaskIntoConstraints = false
        secondImageView.translatesAutoresizingMaskIntoConstraints = false
        
        firstImageView.heightAnchor.constraint(equalTo: combinedStackView.heightAnchor, multiplier: 0.5).isActive = true

        secondImageView.heightAnchor.constraint(equalTo: short.heightAnchor, multiplier: 1).isActive = true
        
        return combinedStackView
    }
    
    func configurateShortStackView() -> UIStackView {
        
        let firstImageView  = imageView(self.imageSource.removeFirst())
        let secondImageView = imageView(self.imageSource.removeFirst())
        
        [firstImageView, secondImageView].shuffled().forEach { (iv) in
            shortStackView.addArrangedSubview(iv)
        }
        
        return shortStackView
    }
    
    func imageView(_ imageURL: String) -> UIImageView {
        let imv = UIImageView()
        imv.loadImage(imageURL, placeHolder: #imageLiteral(resourceName: "image_placeholder"), completion: nil)
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        imageViews.append(imv)
        imv.hero.id = "imv \(imageViews.firstIndex(of: imv)!)"
        return imv
    }
    
    @IBAction func menuHandler(_ sender: Any) {
        
        let menu = StoryboardManager.Menu.instantiateDefaultVC() as! MenuController
        menu.dismissed = { [weak self] in
            self?.fetchCelebs()
        }
        
        show(menu, sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        imageViews.enumerated().forEach { (index, imv) in
            
            if let location = touches.first?.location(in: view)  {
                
                guard imv.superview?.convert(imv.frame, to: view).contains(location) == true else { return }

                let celebVC = StoryboardManager.Celebrity.instantiateDefaultVC() as! CelebrityController
                celebVC.imageViewHeroId = imv.hero.id
                celebVC.celebrity = dataSource[index]
                menuButton.hero.modifiers = [.fade, .translate(CGPoint(x: 150, y: 0))]
                present(celebVC, animated: true, completion: nil)
                
            }
        }
    }
}


