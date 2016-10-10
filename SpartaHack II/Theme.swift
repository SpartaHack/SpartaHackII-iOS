//
//  Theme.swift
//  SpartaHack 2016
//
//  Created by Noah Hines on 9/27/16.
//  Copyright © 2016 Chris McGrath. All rights reserved.
//

import Foundation

struct Theme {
    
    // MARK: Colors
    static let darkBrown = UIColor(red:0.21, green:0.18, blue:0.15, alpha:1.0)
    static let darkGold = UIColor(red:0.71, green:0.54, blue:0.18, alpha:1.0)
    static let mediumGold = UIColor(red:0.83, green:0.69, blue:0.40, alpha:1.0)
    static let lightGold = UIColor(red:0.98, green:0.89, blue:0.64, alpha:1.0)
    static let extraLightGold = UIColor(red:1.00, green:0.95, blue:0.85, alpha:1.0)
    static let white = UIColor(white: 1.0, alpha: 1.0)
    
    // Mark: Gradients
    enum Gradient : Int {
        case lightGradient, darkGradient
        
        func getColors() -> Array<UIColor> {
            switch self {
            case .darkGradient:
                return [darkGold, extraLightGold]
            case .lightGradient:
                return [extraLightGold, white]
            }
        }
    }
    
    // How modular is this code?? :D
    static func setGradient(of type: Gradient, on view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = type.getColors()
        gradientLayer.locations = [0.0, 1.0]
        view.layer.addSublayer(gradientLayer)
    }
        
}