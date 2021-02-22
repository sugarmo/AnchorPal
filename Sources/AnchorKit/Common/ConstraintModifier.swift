//
//  ConstraintModifier.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/6.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public class ConstraintModifier<T>: ConstraintStatement {
    typealias Finalization = (ConstraintMultiplierValuable, ConstraintConstantValuable) -> [NSLayoutConstraint]

    private let finalization: Finalization
    private var multiplier: ConstraintMultiplierValuable = 1.0
    private var constant: ConstraintConstantValuable = 0.0
    private var priority: ConstraintPriorityValuable = LayoutPriority.required

    init(finalization: @escaping Finalization) {
        self.finalization = finalization

        if let builder = ConstraintBuilder.current {
            builder.add(self)
        }
    }

    lazy var constraint: Constraint = {
        let layoutConstraints = finalization(multiplier, constant)
        layoutConstraints.forEach { $0.priority = priority.constraintPriorityValue }
        return Constraint(layoutConstraints: layoutConstraints, constant: constant, priority: priority)
    }()

    @discardableResult
    public func priority(_ amount: ConstraintPriorityValuable) -> ConstraintModifier {
        priority = amount
        return self
    }

    @discardableResult
    public func priority(_ amount: LayoutPriority) -> ConstraintModifier {
        priority = amount
        return self
    }
}

public enum LayoutSystemSpacingTarget {}
public enum ConstraintConstantTarget {}
public protocol LayoutAnchorTargetable {}
public protocol LayoutDimensionTargetable {}

extension LayoutAnchor: LayoutAnchorTargetable {}
extension LayoutDimension: LayoutDimensionTargetable {}
extension CustomLayoutDimension: LayoutDimensionTargetable {}

extension Array: LayoutAnchorTargetable where Element: LayoutAnchorTargetable {}
extension AnchorPair: LayoutAnchorTargetable where F: LayoutAnchorTargetable, S: LayoutAnchorTargetable {}

extension Array: LayoutDimensionTargetable where Element: LayoutDimensionTargetable {}
extension AnchorPair: LayoutDimensionTargetable where F: LayoutDimensionTargetable, S: LayoutDimensionTargetable {}

extension ConstraintModifier where T: LayoutDimensionTargetable {
    @discardableResult
    public func multiply(_ amount: ConstraintMultiplierValuable) -> ConstraintModifier {
        multiplier = amount
        return self
    }

    @discardableResult
    public func plus(_ amount: ConstraintConstantValuable) -> ConstraintModifier {
        constant = amount
        return self
    }
}

extension ConstraintModifier where T: LayoutAnchorTargetable {
    @discardableResult
    public func plus(_ amount: ConstraintConstantValuable) -> ConstraintModifier {
        constant = amount
        return self
    }
}

extension ConstraintModifier where T == LayoutSystemSpacingTarget {
    @discardableResult
    public func multiply(_ amount: ConstraintMultiplierValuable) -> ConstraintModifier {
        multiplier = amount
        return self
    }
}

extension ConstraintModifier where T == ConstraintConstantTarget {
    func constant(_ amount: ConstraintConstantValuable) -> ConstraintModifier {
        constant = amount
        return self
    }
}
