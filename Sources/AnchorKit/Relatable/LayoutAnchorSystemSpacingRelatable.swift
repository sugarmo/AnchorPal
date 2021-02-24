//
//  LayoutAnchorSystemSpacingRelatable.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/24.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

@available(iOS 11, tvOS 11, macOS 11, *)
public protocol LayoutAnchorSystemSpacingRelatable {
    static func constraints(first: Self, relation: ConstraintRelation, toSystemSpacingAfter second: Self, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint]
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension LayoutAnchor: LayoutAnchorSystemSpacingRelatable {
    public static func constraints(first: LayoutAnchor<T>, relation: ConstraintRelation, toSystemSpacingAfter other: LayoutAnchor<T>, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        let mv = multiplier.constraintMultiplierValue
        return [first.rawValue.constraint(relation, toSystemSpacingAfter: other.rawValue, multiplier: mv)]
    }
}

// @available(iOS 11, tvOS 11, macOS 11, *)
// extension Array: LayoutAnchorSystemSpacingRelatable where Element: LayoutAnchorSystemSpacingRelatable {
//    public static func constraints(first: Array<Element>, relation: ConstraintRelation, toSystemSpacingAfter second: Array<Element>, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
//        first.enumerated().flatMap { (index, element) -> [NSLayoutConstraint] in
//            Element.constraints(first: element, relation: relation, toSystemSpacingAfter: second[index], multiplier: multiplier)
//        }
//    }
// }
//
// @available(iOS 11, tvOS 11, macOS 11, *)
// extension AnchorPair: LayoutAnchorSystemSpacingRelatable where F: LayoutAnchorSystemSpacingRelatable, S: LayoutAnchorSystemSpacingRelatable {
//    public static func constraints(first: AnchorPair<F, S>, relation: ConstraintRelation, toSystemSpacingAfter second: AnchorPair<F, S>, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
//        F.constraints(first: first.first, relation: relation, toSystemSpacingAfter: second.first, multiplier: multiplier) +
//            S.constraints(first: first.second, relation: relation, toSystemSpacingAfter: second.second, multiplier: multiplier)
//    }
// }

@available(iOS 11, tvOS 11, macOS 11, *)
extension LayoutAnchorSystemSpacingRelatable {
    func state(_ relation: ConstraintRelation, toSystemSpacingAfter other: Self) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        ConstraintModifier { (m, _) -> [NSLayoutConstraint] in
            Self.constraints(first: self, relation: relation, toSystemSpacingAfter: other, multiplier: m)
        }
    }

    @discardableResult
    public func lessEqualToSystemSpacingAfter(_ other: Self) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.lessEqual, toSystemSpacingAfter: other)
    }

    @discardableResult
    public func equalToSystemSpacingAfter(_ other: Self) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.equal, toSystemSpacingAfter: other)
    }

    @discardableResult
    public func greaterEqualToSystemSpacingAfter(_ other: Self) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.greaterEqual, toSystemSpacingAfter: other)
    }
}
