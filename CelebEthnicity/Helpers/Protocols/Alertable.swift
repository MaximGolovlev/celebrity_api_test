import Foundation
import UIKit

protocol Alertable {
    func showAlert(title: String?, message: String?)
    func showAlert(title: String?, message: String?, handler: @escaping ((UIAlertAction) -> Void))
}

extension Alertable where Self: UIViewController {
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(close)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String?, message: String?, handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alert.addAction(close)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String?, subtitle: String?, option1: String?, option2: String?, handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        let first = UIAlertAction(title: option1, style: .default, handler: handler)
        let close = UIAlertAction(title: option2, style: .cancel, handler: handler)
        alert.addAction(first)
        alert.addAction(close)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(senderRect: CGRect? = nil, title: String?, subtitle: String?, option1: String?, syle1: UIAlertAction.Style = .destructive, option2: String?, handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .actionSheet)
        let first = UIAlertAction(title: option1, style: syle1, handler: handler)
        let close = UIAlertAction(title: option2, style: .cancel, handler: handler)
        alert.addAction(first)
        alert.addAction(close)
        
        if let senderRect = senderRect {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = senderRect
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(sender: UIView? = nil, title: String, subtitle: String, textFieldNames:[String], buttonsName: [String],handler: @escaping ((UIAlertAction, [String]) -> Void)) {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        alert.addTextField { (tf) in
            tf.placeholder = textFieldNames[0]
        }
        
        alert.addTextField { (tf) in
            tf.placeholder = textFieldNames[1]
        }
        
        let cancel = UIAlertAction(title: buttonsName[0], style: .cancel) { (action) in
            handler(action, [])
        }
        alert.addAction(cancel)
        
        let enter = UIAlertAction(title: buttonsName[1], style: .default) { (action) in
            handler(action, alert.textFields?.compactMap { $0.text } ?? [])
        }
        alert.addAction(enter)
        
        if let sender = sender {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = sender.frame
        }
        
        present(alert, animated: true, completion: nil)
    }
}
