//
//  ExUIView.swift
//  NYTimes
//
//  Created by melaabd on 1/20/22.
//

import UIKit

extension UIView {
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
    
    func remove() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
}
