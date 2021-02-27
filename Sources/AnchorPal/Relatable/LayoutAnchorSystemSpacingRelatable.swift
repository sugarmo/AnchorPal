//
//  LayoutAnchorSystemSpacingRelatable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/24.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public enum LayoutSpacePosition {
    case after
    case before
}

@available(iOS 11, tvOS 11, macOS 11, *)
public protocol LayoutAnchorSystemSpacingRelatable: ConstraintSubjectable {
    static func constraints(first: Self, relation: ConstraintRelation, toSystemSpacing position: LayoutSpacePosition, second: Self, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint]
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension LayoutAnchor: LayoutAnchorSystemSpacingRelatable {
    public static func constraints(first: LayoutAnchor<T>, relation: ConstraintRelation, toSystemSpacing position: LayoutSpacePosition, second: LayoutAnchor<T>, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        let mv = multiplier.constraintMultiplierValue
        switch position {
        case .after:
            return [first.rawValue.constraint(relation, toSystemSpacingAfter: second.rawValue, multiplier: mv)]
        case .before:
            return [second.rawValue.constraint(relation, toSystemSpacingAfter: first.rawValue, multiplier: mv)]
        }
    }
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension LayoutAnchorSystemSpacingRelatable {
    func state(_ relation: ConstraintRelation, toSystemSpacing position: LayoutSpacePosition, _ other: Self) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        ConstraintModifier(subjectProvider: self) { (m, _) -> [NSLayoutConstraint] in
            Self.constraints(first: self, relation: relation, toSystemSpacing: position, second: other, multiplier: m)
        }
    }

    // MARK: After

    @discardableResult
    public func lessEqualToSystemSpacingAfter(_ other: Self) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.lessEqual, toSystemSpacing: .after, other)
    }

    @discardableResult
    public func equalToSystemSpacingAfter(_ other: Self) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.equal, toSystemSpacing: .after, other)
    }

    @discardableResult
    public func greaterEqualToSystemSpacingAfter(_ other: Self) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.greaterEqual, toSystemSpacing: .after, other)
    }

    // MARK: Before

    @discardableResult
    public func lessEqualToSystemSpacingBefore(_ other: Self) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.lessEqual, toSystemSpacing: .before, other)
    }

    @discardableResult
    public func equalToSystemSpacingBefore(_ other: Self) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.equal, toSystemSpacing: .before, other)
    }

    @discardableResult
    public func greaterEqualToSystemSpacingBefore(_ other: Self) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.greaterEqual, toSystemSpacing: .before, other)
    }
}
