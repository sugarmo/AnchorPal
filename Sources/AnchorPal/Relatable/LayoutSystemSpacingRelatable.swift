//
//  LayoutSystemSpacingRelatable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/11.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

@available(iOS 11, tvOS 11, macOS 11, *)
public protocol LayoutSystemSpacingRelatable: ConstraintSubjectable {
    static func constraints(first: Self, relationToSystemSpacing relation: ConstraintRelation, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint]
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension CustomLayoutDimension: LayoutSystemSpacingRelatable {
    public static func constraints(first: CustomLayoutDimension<T>, relationToSystemSpacing relation: ConstraintRelation, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        let mv = multiplier.constraintMultiplierValue
        return [first.trailing.constraint(relation, toSystemSpacingAfter: first.leading, multiplier: mv)]
    }
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension LayoutInset: LayoutSystemSpacingRelatable {
    public static func constraints(first: LayoutInset<T>, relationToSystemSpacing relation: ConstraintRelation, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        let mv = multiplier.constraintMultiplierValue
        return [first.trailing.constraint(relation, toSystemSpacingAfter: first.leading, multiplier: mv)]
    }
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension Array: LayoutSystemSpacingRelatable where Element: LayoutSystemSpacingRelatable {
    public static func constraints(first: Array<Element>, relationToSystemSpacing relation: ConstraintRelation, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        first.flatMap { Element.constraints(first: $0, relationToSystemSpacing: relation, multiplier: multiplier) }
    }
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension AnchorPair: LayoutSystemSpacingRelatable where F: LayoutSystemSpacingRelatable, S: LayoutSystemSpacingRelatable {
    public static func constraints(first: AnchorPair<F, S>, relationToSystemSpacing relation: ConstraintRelation, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        F.constraints(first: first.first, relationToSystemSpacing: relation, multiplier: multiplier) +
            S.constraints(first: first.second, relationToSystemSpacing: relation, multiplier: multiplier)
    }
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension LayoutSystemSpacingRelatable {
    func stateToSystemSpacing(_ relation: ConstraintRelation) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        ConstraintModifier(subjectProvider: self) { (m, _) -> [NSLayoutConstraint] in
            Self.constraints(first: self, relationToSystemSpacing: relation, multiplier: m)
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
