//
//  AlertDelegate.swift
//  NYTimes
//
//  Created by melaabd on 20/01/2022.
//

import UIKit

/// AlertDelegate
protocol AlertDelegate {
    typealias Events = (_ retry: Bool)-> Void
    
    func showAlertWithError(_ message: String, completionHandler: @escaping Events)
}

// MARK: - Implement AlertDelegate with UIViewController
extension AlertDelegate where Self: UIViewController{
    
    //MARK:- Show Error Alert
    func showAlertWithError(_ message: String, completionHandler: @escaping Events) {
        let alert = UIAlertController(title: NSLocalizedString("Opps!", comment: ""),
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                      style: .cancel,
                                      handler: nil))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""),
                                      style: .default,
                                      handler: { _ in completionHandler(true) }))
        present(alert, animated: true, completion: nil)
    }
}
