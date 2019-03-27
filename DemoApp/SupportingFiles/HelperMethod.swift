//
//  HelperMethod.swift
//  DemoApp
//
//  Created by Shivpoojan Jaiswal on 24/03/2019.
//  Copyright © 2019 Shivpoojan Jaiswal. All rights reserved.
//

import Foundation
import Reachability

class HelperMethod {
    
    static let sharedInstance = HelperMethod()
    
    //Method to check internet connectivity.
    func isConnectivityOn() -> Bool {
        let reachability = Reachability()!
        if reachability.connection == .wifi || reachability.connection == .cellular {
            return true
        } else {
            return false
        }
    }
}

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
