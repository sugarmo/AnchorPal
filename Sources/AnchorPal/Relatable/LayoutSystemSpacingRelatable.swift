//
//  LayoutSystemSpacingRelatable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/11.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

@available(iOS 11, tvOS 11, macOS 11, *)
public protocol LayoutSystemSpacingRelatable: ConstraintSubjectable {
    static func constraints(_ receiver: Self, relationToSystemSpacing relation: ConstraintRelation, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint]
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension CustomLayoutDimension: LayoutSystemSpacingRelatable {
    public static func constraints(_ receiver: CustomLayoutDimension<T>, relationToSystemSpacing relation: ConstraintRelation, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        let mv = multiplier.constraintMultiplierValue
        return [receiver.trailing.constraint(relation, toSystemSpacingAfter: receiver.leading, multiplier: mv)]
    }
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension LayoutInset: LayoutSystemSpacingRelatable {
    public static func constraints(_ receiver: LayoutInset<T>, relationToSystemSpacing relation: ConstraintRelation, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        let mv = multiplier.constraintMultiplierValue
        return [receiver.trailing.constraint(relation, toSystemSpacingAfter: receiver.leading, multiplier: mv)]
    }
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension Array: LayoutSystemSpacingRelatable where Element: LayoutSystemSpacingRelatable {
    public static func constraints(_ receiver: [Element], relationToSystemSpacing relation: ConstraintRelation, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        receiver.flatMap { Element.constraints($0, relationToSystemSpacing: relation, multiplier: multiplier) }
    }
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension AnchorPair: LayoutSystemSpacingRelatable where F: LayoutSystemSpacingRelatable, S: LayoutSystemSpacingRelatable {
    public static func constraints(_ receiver: AnchorPair<F, S>, relationToSystemSpacing relation: ConstraintRelation, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        F.constraints(receiver.first, relationToSystemSpacing: relation, multiplier: multiplier) +
            S.constraints(receiver.second, relationToSystemSpacing: relation, multiplier: multiplier)
    }
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension LayoutSystemSpacingRelatable {
    func stateToSystemSpacing(_ relation: ConstraintRelation) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        ConstraintModifier(subjectProvider: self) { m, _ -> [NSLayoutConstraint] in
            Self.constraints(self, relationToSystemSpacing: relation, multiplier: m)
        }
    }

    @discardableResult
    public func lessEqualToSystemSpacing() -> ConstraintModifier<LayoutSystemSpacingTarget> {
        stateToSystemSpacing(.lessEqual)
    }

    @discardableResult
    public func equalToSystemSpacing() -> ConstraintModifier<LayoutSystemSpacingTarget> {
        stateToSystemSpacing(.equal)
    }

    @discardableResult
    public func greaterEqualToSystemSpacing() -> ConstraintModifier<LayoutSystemSpacingTarget> {
        stateToSystemSpacing(.greaterEqual)
    }
}
