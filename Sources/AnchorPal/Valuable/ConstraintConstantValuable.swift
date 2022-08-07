//
//  ConstraintConstantValuable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/2.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public protocol ConstraintConstantValuable {
    func constraintConstantValue(for position: AnchorPosition) -> CGFloat
}

extension CGFloat: ConstraintConstantValuable {
    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        self
    }
}

extension CGFloatConvertible where Self: ConstraintConstantValuable {
    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        cgFloatValue
    }
}

extension Int: ConstraintConstantValuable {}
extension UInt: ConstraintConstantValuable {}
extension Float: ConstraintConstantValuable {}
extension Double: ConstraintConstantValuable {}

extension CGPoint: ConstraintConstantValuable {
    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        switch position.axis {
        case .horizontal:
            return x
        case .vertical:
            return y
        }
    }
}

extension CGSize: ConstraintConstantValuable {
    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        switch position.axis {
        case .horizontal:
            return width
        case .vertical:
            return height
        }
    }
}

extension EdgeInsets: ConstraintConstantValuable {
    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        switch position {
        case .leading:
            return left
        case .trailing:
            return right
        case .top:
            return top
        case .bottom:
            return bottom
        default:
            return 0
        }
    }
}

extension DirectionalEdgeInsets: ConstraintConstantValuable {
    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        switch position {
        case .leading:
            return leading
        case .trailing:
            return trailing
        case .top:
            return top
        case .bottom:
            return bottom
        default:
            return 0
        }
    }
}

public struct DynamicConstraintConstant<Value>: ConstraintConstantValuable where Value: ConstraintConstantValuable {
    var getter: () -> Value

    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        getter().constraintConstantValue(for: position)
    }
}
