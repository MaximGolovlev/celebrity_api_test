import Foundation
import MBProgressHUD
import UIKit

protocol Loadable: class {
    func startLoading()
    func stopLoading()
    func showSuccess()
}

extension Loadable where Self: UIViewController {
    func startLoading() {
        MBProgressHUD.showAdded(to: view, animated: false)
    }
    
    func stopLoading() {
        MBProgressHUD.hide(for: view, animated: false)
    }
    
    func showSuccess() {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        hud.customView = UIImageView(image: #imageLiteral(resourceName: "Check")) // according to the documentation a good image size is something like 37x37px
    //    hud.label.text = "Completed"
    }
}

