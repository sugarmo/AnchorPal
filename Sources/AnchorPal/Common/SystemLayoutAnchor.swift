//
//  SystemLayoutAnchor.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/7.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public protocol SystemLayoutAnchor: NSObject {
    func constraint(_ relation: ConstraintRelation, to anchor: Self, constant: CGFloat, position: AnchorPosition) -> NSLayoutConstraint

    func constraint(_ relation: ConstraintRelation, toSystemSpacingAfter anchor: Self, multiplier: CGFloat) -> NSLayoutConstraint

    static var customDimensionPosition: AnchorPosition { get }

        func anchorWithOffset(to otherAnchor: Self) -> NSLayoutDimension
}

extension NSLayoutXAxisAnchor: SystemLayoutAnchor {
    public static let customDimensionPosition: AnchorPosition = .centerX
}

extension NSLayoutYAxisAnchor: SystemLayoutAnchor {
    public static let customDimensionPosition: AnchorPosition = .centerY
}

public extension NSLayoutXAxisAnchor {
    func constraint(_ relation: ConstraintRelation, to anchor: NSLayoutXAxisAnchor, constant: CGFloat, position: AnchorPosition) -> NSLayoutConstraint {
        switch relation {
        case .lessEqual:
            return constraint(lessThanOrEqualTo: anchor, constant: constant).position(position)
        case .equal:
            return constraint(equalTo: anchor, constant: constant).position(position)
        case .greaterEqual:
            return constraint(greaterThanOrEqualTo: anchor, constant: constant).position(position)
        }
    }

    func constraint(_ relation: ConstraintRelation, toSystemSpacingAfter anchor: NSLayoutXAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        switch relation {
        case .lessEqual:
            return constraint(lessThanOrEqualToSystemSpacingAfter: anchor, multiplier: multiplier)
        case .equal:
            return constraint(equalToSystemSpacingAfter: anchor, multiplier: multiplier)
        case .greaterEqual:
            return constraint(greaterThanOrEqualToSystemSpacingAfter: anchor, multiplier: multiplier)
        }
    }
}

public extension NSLayoutYAxisAnchor {
    func constraint(_ relation: ConstraintRelation, to anchor: NSLayoutYAxisAnchor, constant: CGFloat, position: AnchorPosition) -> NSLayoutConstraint {
        switch relation {
        case .lessEqual:
            return constraint(lessThanOrEqualTo: anchor, constant: constant).position(position)
        case .equal:
            return constraint(equalTo: anchor, constant: constant).position(position)
        case .greaterEqual:
            return constraint(greaterThanOrEqualTo: anchor, constant: constant).position(position)
        }
    }

    func constraint(_ relation: ConstraintRelation, toSystemSpacingAfter anchor: NSLayoutYAxisAnchor, multiplier: CGFloat) -> NSLayoutConstraint {
        switch relation {
        case .lessEqual:
            return constraint(lessThanOrEqualToSystemSpacingBelow: anchor, multiplier: multiplier)
        case .equal:
            return constraint(equalToSystemSpacingBelow: anchor, multiplier: multiplier)
        case .greaterEqual:
            return constraint(greaterThanOrEqualToSystemSpacingBelow: anchor, multiplier: multiplier)
        }
    }
}

public extension NSLayoutDimension {
    func constraint(_ relation: ConstraintRelation, to dimension: NSLayoutDimension, multiplier: CGFloat, constant: CGFloat, position: AnchorPosition) -> NSLayoutConstraint {
        switch relation {
        case .lessEqual:
            return constraint(lessThanOrEqualTo: dimension, multiplier: multiplier, constant: constant).position(position)
        case .equal:
            return constraint(equalTo: dimension, multiplier: multiplier, constant: constant).position(position)
        case .greaterEqual:
            return constraint(greaterThanOrEqualTo: dimension, multiplier: multiplier, constant: constant).position(position)
        }
    }

    func constraint(_ relation: ConstraintRelation, toConstant constant: CGFloat, position: AnchorPosition) -> NSLayoutConstraint {
        switch relation {
        case .lessEqual:
            return constraint(lessThanOrEqualToConstant: constant).position(position)
        case .equal:
            return constraint(equalToConstant: constant).position(position)
        case .greaterEqual:
            return constraint(greaterThanOrEqualToConstant: constant).position(position)
        }
    }
}
