//
//  CustomView.swift
//  3D Storage
//
//
//  Created by Avadh on 09/05/22.
//

import UIKit

// MARK: Custom View Class
class CustomView: UIView {

    // MARK: Set View cornerRadius
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    // MARK: Set View borderWidth
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    // MARK: Set View borderColor
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case left, right, top, bottom, none
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
        case .right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
        case .top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness)
        case .bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        default: break
        }
        
        layer.addSublayer(border)
    }
    
    func addBorderToView(thickness: CGFloat = 1, color: UIColor) {
        self.layer.borderWidth = thickness
        self.layer.borderColor = color.cgColor
    }
    
    public class func fromNib<T: UIView>() -> T? {
        let name = String(describing: Self.self)
        guard let nib = Bundle(for: Self.self).loadNibNamed(
            name, owner: nil, options: nil)
        else {
            fatalError("Missing nib-file named: \(name)")
        }
        return nib.first as? T
    }
    
    func roundCorners(radius: CGFloat = 10, corners: UIRectCorner = .allCorners) {
        //        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            var arr: CACornerMask = []
            let allCorners: [UIRectCorner] = [.topLeft, .topRight, .bottomLeft, .bottomRight, .allCorners]
            for corn in allCorners where (corners.contains(corn)) {
                switch corn {
                case .topLeft:
                    arr.insert(.layerMinXMinYCorner)
                case .topRight:
                    arr.insert(.layerMaxXMinYCorner)
                case .bottomLeft:
                    arr.insert(.layerMinXMaxYCorner)
                case .bottomRight:
                    arr.insert(.layerMaxXMaxYCorner)
                case .allCorners:
                    arr.insert(.layerMinXMinYCorner)
                    arr.insert(.layerMaxXMinYCorner)
                    arr.insert(.layerMinXMaxYCorner)
                    arr.insert(.layerMaxXMaxYCorner)
                default: break
                }
            }
            self.layer.maskedCorners = arr
        } else {
            self.roundCornersBezierPath(corners: corners, radius: radius)
        }
    }
    
    private func roundCornersBezierPath(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
