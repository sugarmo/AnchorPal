//
//  ConstraintMultiplierValuable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/10.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public protocol ConstraintMultiplierValuable {
    var constraintMultiplierValue: CGFloat { get }
}

extension CGFloat: ConstraintMultiplierValuable {
    public var constraintMultiplierValue: CGFloat {
        self
    }
}

extension ConstraintMultiplierValuable where Self: CGFloatConvertible {
    public var constraintMultiplierValue: CGFloat {
        cgFloatValue
    }
}

extension Int: ConstraintMultiplierValuable {}

extension UInt: ConstraintMultiplierValuable {}

extension Float: ConstraintMultiplierValuable {}

extension Double: ConstraintMultiplierValuable {}
