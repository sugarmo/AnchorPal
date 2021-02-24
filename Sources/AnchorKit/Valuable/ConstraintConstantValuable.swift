//
//  ConstraintConstantValuable.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/2.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
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
        case .leadingX:
            return left
        case .trailingX:
            return right
        case .leadingY:
            return top
        case .trailingY:
            return bottom
        default:
            return 0
        }
    }
}

@available(iOS 11, tvOS 11, macOS 10.15, *)
extension DirectionalEdgeInsets: ConstraintConstantValuable {
    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        switch position {
        case .leadingX:
            return leading
        case .trailingX:
            return trailing
        case .leadingY:
            return top
        case .trailingY:
            return bottom
        default:
            return 0
        }
    }
}

public struct DynamicConstraintConstant: ConstraintConstantValuable {
    public typealias Getter = (AnchorPosition) -> CGFloat

    var getter: Getter

    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        getter(position)
    }
}
