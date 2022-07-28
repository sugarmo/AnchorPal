//
//  ConstraintPriorityValuable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/2.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public protocol ConstraintPriorityValuable {
    var constraintPriorityValue: LayoutPriority { get }
}

extension CGFloat: ConstraintPriorityValuable {
    public var constraintPriorityValue: LayoutPriority {
        LayoutPriority(rawValue: Float(self))
    }
}

extension Int: ConstraintPriorityValuable {
    public var constraintPriorityValue: LayoutPriority {
        LayoutPriority(rawValue: Float(self))
    }
}

extension UInt: ConstraintPriorityValuable {
    public var constraintPriorityValue: LayoutPriority {
        LayoutPriority(rawValue: Float(self))
    }
}

extension Float: ConstraintPriorityValuable {
    public var constraintPriorityValue: LayoutPriority {
        LayoutPriority(rawValue: Float(self))
    }
}

extension Double: ConstraintPriorityValuable {
    public var constraintPriorityValue: LayoutPriority {
        LayoutPriority(rawValue: Float(self))
    }
}

extension ConstraintPriority: ConstraintPriorityValuable {
    public var constraintPriorityValue: LayoutPriority {
        LayoutPriority(rawValue: rawValue)
    }
}
