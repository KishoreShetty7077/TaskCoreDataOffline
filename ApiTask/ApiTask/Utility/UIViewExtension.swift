//
//  UIViewExtension.swift
//  ApiCall
//
//  Created by Kishore B on 11/7/24.
//

import Foundation
import UIKit

extension UIView {
 
    func applyCardShadow(cornerRadius: CGFloat = 8, shadowColor: UIColor = .gray, shadowOpacity: Float = 0.1, shadowOffset: CGSize = CGSize(width: 1, height: 1), shadowRadius: CGFloat = 10) {
        // Set corner radius
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        
        // Set shadow properties
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        
        // Apply shadow path for better performance
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
    }
}
