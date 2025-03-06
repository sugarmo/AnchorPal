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
    let getter: () -> Value

    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        getter().constraintConstantValue(for: position)
    }
}

public struct FontMetricsConstraintConstant<Value>: ConstraintConstantValuable where Value: ConstraintConstantValuable {
    let originalValue: Value
    let minimumValue: Value?
    let maximumValue: Value?
    private let scaledValue: (CGFloat) -> CGFloat

    init(originalValue: Value, textStyle: Font.TextStyle, minimumValue: Value? = nil, maximumValue: Value? = nil) {
        self.originalValue = originalValue
        #if os(iOS) || os(tvOS)
            let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
            scaledValue = { fontMetrics.scaledValue(for: $0) }
        #else
            let preferredFont = NSFont.preferredFont(forTextStyle: textStyle)
            let ratio = preferredFont.pointSize / NSFont.systemFont(ofSize: 0).pointSize
            scaledValue = { $0 * ratio }
        #endif

        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }

    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        let originalValue = originalValue.constraintConstantValue(for: position)
        var scaledValue = scaledValue(originalValue)

        if let minimumValue {
            scaledValue = max(scaledValue, minimumValue.constraintConstantValue(for: position))
        }

        if let maximumValue {
            scaledValue = min(scaledValue, maximumValue.constraintConstantValue(for: position))
        }

        return scaledValue
    }
}
