//
//  File.swift
//  PropertyBooking
//
//  Created by Muhammad Farooq on 2021-02-16.
//

import UIKit

@IBDesignable class DropDownButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        sizeToFit()
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageRect(forContentRect: bounds).width - 30.0, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: -2, right: 0)
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
        
        layer.cornerRadius = 4.0
        clipsToBounds = true
        layer.masksToBounds = true
    }
}
