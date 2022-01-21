//
//  ExUIView.swift
//  NYTimes
//
//  Created by melaabd on 1/20/22.
//

import UIKit

extension UIView {
    
    /// create indicator view and show it on the top
    /// - Returns: `UIView`
    func showSpinner() -> UIView {
        let spinnerView = UIView.init(frame: bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        let ai = UIActivityIndicatorView.init(style: .medium)
        ai.startAnimating()
        ai.center = spinnerView.center
        DispatchQueue.main.async { [weak self] in
            spinnerView.addSubview(ai)
            self?.addSubview(spinnerView)
        }
        spinnerView.center = center
        return spinnerView
    }
    
    /// remove view from it's super view
    func remove() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
}
