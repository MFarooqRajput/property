//
//  BorderButton.swift
//  PropertyBooking
//
//  Created by Muhammad Farooq on 2021-02-16.
//

import UIKit

class CustomButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
