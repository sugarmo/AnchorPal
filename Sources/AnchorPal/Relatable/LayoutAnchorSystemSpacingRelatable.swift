//
//  LayoutAnchorSystemSpacingRelatable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/24.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public enum LayoutSpacePosition {
    case after
    case before
}

public protocol LayoutAnchorSystemSpacingRelatable: ConstraintSubjectable {
    associatedtype Other

    static func constraints(_ receiver: Self, relation: ConstraintRelation, toSystemSpacing position: LayoutSpacePosition, other: Other, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint]
}

extension LayoutAnchor: LayoutAnchorSystemSpacingRelatable {
    public static func constraints(_ receiver: LayoutAnchor<T>, relation: ConstraintRelation, toSystemSpacing position: LayoutSpacePosition, other: LayoutAnchor<T>, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        let mv = multiplier.constraintMultiplierValue
        switch position {
        case .after:
            return [receiver.rawValue.constraint(relation, toSystemSpacingAfter: other.rawValue, multiplier: mv)]
        case .before:
            return [other.rawValue.constraint(relation, toSystemSpacingAfter: receiver.rawValue, multiplier: mv)]
        }
    }
}

extension Array: LayoutAnchorSystemSpacingRelatable where Element: LayoutAnchorSystemSpacingRelatable {
    public static func constraints(_ receiver: [Element], relation: ConstraintRelation, toSystemSpacing position: LayoutSpacePosition, other: Element.Other, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        receiver.flatMap {
            Element.constraints($0, relation: relation, toSystemSpacing: position, other: other, multiplier: multiplier)
        }
    }
}

extension AnchorPair: LayoutAnchorSystemSpacingRelatable where F: LayoutAnchorSystemSpacingRelatable, S: LayoutAnchorSystemSpacingRelatable {
    public static func constraints(_ receiver: AnchorPair, relation: ConstraintRelation, toSystemSpacing position: LayoutSpacePosition, other: AnchorPair<F.Other, S.Other>, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        F.constraints(receiver.first, relation: relation, toSystemSpacing: position, other: other.first, multiplier: multiplier) +
            S.constraints(receiver.second, relation: relation, toSystemSpacing: position, other: other.second, multiplier: multiplier)
    }
}

extension LayoutAnchorSystemSpacingRelatable {
    func state(_ relation: ConstraintRelation, toSystemSpacing position: LayoutSpacePosition, other: Other) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        ConstraintModifier(subjectProvider: self) { m, _ -> [NSLayoutConstraint] in
            Self.constraints(self, relation: relation, toSystemSpacing: position, other: other, multiplier: m)
        }
    }

    // MARK: After

    @discardableResult
    public func lessEqualToSystemSpacingAfter(_ other: Other) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.lessEqual, toSystemSpacing: .after, other: other)
    }

    @discardableResult
    public func equalToSystemSpacingAfter(_ other: Other) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.equal, toSystemSpacing: .after, other: other)
    }

    @discardableResult
    public func greaterEqualToSystemSpacingAfter(_ other: Other) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.greaterEqual, toSystemSpacing: .after, other: other)
    }

    // MARK: Before

    @discardableResult
    public func lessEqualToSystemSpacingBefore(_ other: Other) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.lessEqual, toSystemSpacing: .before, other: other)
    }

    @discardableResult
    public func equalToSystemSpacingBefore(_ other: Other) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.equal, toSystemSpacing: .before, other: other)
    }

    @discardableResult
    public func greaterEqualToSystemSpacingBefore(_ other: Other) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.greaterEqual, toSystemSpacing: .before, other: other)
    }
}
