//
//  CustomLabel.swift
//  3D Storage
//
//
//  Created by Avadh on 09/05/22.
//

import UIKit

// MARK: Custom Label Class
// @IBDesignable
class CustomLabel: UILabel {

    // MARK: Set Label cornerRadius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    // MARK: Set Label borderWidth
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    // MARK: Set Label borderColor
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

}


