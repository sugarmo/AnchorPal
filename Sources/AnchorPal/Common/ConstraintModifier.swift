//
//  ConstraintModifier.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/6.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public final class ConstraintModifier<Target>: ConstraintStatement {
    typealias Finalization = (ConstraintMultiplierValuable, ConstraintConstantValuable) -> [NSLayoutConstraint]

    private let finalization: Finalization
    private let subjectItems: [LayoutItem]
    private var multiplier: ConstraintMultiplierValuable = 1.0
    private var constant: ConstraintConstantValuable = 0.0
    private var priority: ConstraintPriorityValuable = ConstraintPriority.required

    init<U>(subjectProvider: U, finalization: @escaping Finalization) where U: ConstraintSubjectable {
        subjectItems = U.subjectItems(for: subjectProvider)
        self.finalization = finalization

        if let builder = ConstraintBuilder.current {
            builder.add(self)
        }
    }

    public lazy var constraint: Constraint = {
        let layoutConstraints = finalization(multiplier, constant)
        layoutConstraints.forEach { $0.priority = priority.constraintPriorityValue }
        return Constraint(subjectItems: subjectItems, layoutConstraints: layoutConstraints, constant: constant, priority: priority)
    }()

    @discardableResult
    public func activate() -> Constraint {
        let c = constraint
        c.activate()
        return c
    }

    @discardableResult
    public func priority(_ amount: ConstraintPriorityValuable) -> ConstraintModifier {
        priority = amount
        return self
    }

    @discardableResult
    public func priority(_ amount: ConstraintPriority) -> ConstraintModifier {
        priority = amount
        return self
    }

    func _multiply(_ amount: ConstraintMultiplierValuable) -> ConstraintModifier {
        multiplier = amount
        return self
    }

    func _constant(_ amount: ConstraintConstantValuable) -> ConstraintModifier {
        constant = amount
        return self
    }

    func _constant<T>(_ dynamicConstant: @escaping () -> T) -> ConstraintModifier where T: ConstraintConstantValuable {
        constant = DynamicConstraintConstant(getter: dynamicConstant)
        return self
    }
}

public enum LayoutSystemSpacingTarget {}
public protocol LayoutAnchorTargetable {}
public protocol LayoutDimensionTargetable {}

extension LayoutAnchor: LayoutAnchorTargetable {}
extension LayoutDimension: LayoutDimensionTargetable {}
extension CustomLayoutDimension: LayoutDimensionTargetable {}

extension Array: LayoutAnchorTargetable where Element: LayoutAnchorTargetable {}
extension AnchorPair: LayoutAnchorTargetable where F: LayoutAnchorTargetable, S: LayoutAnchorTargetable {}

extension Array: LayoutDimensionTargetable where Element: LayoutDimensionTargetable {}
extension AnchorPair: LayoutDimensionTargetable where F: LayoutDimensionTargetable, S: LayoutDimensionTargetable {}

extension ConstraintModifier where Target: LayoutDimensionTargetable {
    @discardableResult
    public func multiply(_ amount: CGFloat) -> ConstraintModifier {
        _multiply(amount)
    }

    @discardableResult
    public func multiply(_ amount: ConstraintMultiplierValuable) -> ConstraintModifier {
        _multiply(amount)
    }

    @discardableResult
    public func plus(_ amount: CGFloat) -> ConstraintModifier {
        _constant(amount)
    }

    @discardableResult
    public func plus(_ amount: ConstraintConstantValuable) -> ConstraintModifier {
        _constant(amount)
    }

    @discardableResult
    public func plus<T>(_ dynamicConstant: @escaping () -> T) -> ConstraintModifier where T: ConstraintConstantValuable {
        _constant(dynamicConstant)
    }
}

extension ConstraintModifier where Target: LayoutAnchorTargetable {
    @discardableResult
    public func plus(_ amount: CGFloat) -> ConstraintModifier {
        _constant(amount)
    }

    @discardableResult
    public func plus(_ amount: ConstraintConstantValuable) -> ConstraintModifier {
        _constant(amount)
    }

    @discardableResult
    public func plus<T>(_ dynamicConstant: @escaping () -> T) -> ConstraintModifier where T: ConstraintConstantValuable {
        _constant(dynamicConstant)
    }
}

extension ConstraintModifier where Target == LayoutSystemSpacingTarget {
    @discardableResult
    public func multiply(_ amount: CGFloat) -> ConstraintModifier {
        _multiply(amount)
    }

    @discardableResult
    public func multiply(_ amount: ConstraintMultiplierValuable) -> ConstraintModifier {
        _multiply(amount)
    }
}
