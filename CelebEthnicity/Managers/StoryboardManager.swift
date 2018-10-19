//
//  StoryboardManager.swift
//  CelebEthnicity
//
//  Created by User on 16.10.2018.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit

enum ViewControllerKey: String {
    case menu = "MenuController"
    case feed = "FeedController"
    case celebrity = "CelebrityController"
    case addCelebrity = "AddCelebrityController"
}

protocol StoryboardManagerable {
    var storyboardName: String { get }
    var controllerIdentifier: String { get }
    func instantiateVC(key: ViewControllerKey) -> UIViewController
    func instantiateDefaultVC() -> UIViewController
    func instantiateInitialVC() -> UIViewController?
}

enum StoryboardManager {
    case Feed
    case Menu
    case Celebrity
    case AddCelebrity
}

extension StoryboardManager: StoryboardManagerable {
    
    var storyboardName: String {
        switch self {
        case .Feed:
            return "FeedController"
        case .Menu:
            return "MenuController"
        case .Celebrity:
            return "CelebrityController"
        case .AddCelebrity:
            return "AddCelebrityController"
        }
    }
    
    var controllerIdentifier: String {
        switch self {
        case .Feed:
            return "FeedController"
        case .Menu:
            return "MenuController"
        case .Celebrity:
            return "CelebrityController"
        case .AddCelebrity:
            return "AddCelebrityController"
        }
    }
    
    func instantiateVC(key: ViewControllerKey) -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: key.rawValue)
    }
    
    func instantiateDefaultVC() -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: controllerIdentifier)
    }
    
    func instantiateInitialVC() -> UIViewController? {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()
    }

}
