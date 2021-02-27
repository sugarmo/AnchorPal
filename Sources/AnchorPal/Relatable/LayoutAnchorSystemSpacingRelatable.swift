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
    associatedtype AxisAnchor: SystemLayoutAnchor

    static func constraints(first: Self, relation: ConstraintRelation, toSystemSpacing position: LayoutSpacePosition, second: LayoutAnchor<AxisAnchor>, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint]
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
extension Array: LayoutAnchorSystemSpacingRelatable where Element: LayoutAnchorSystemSpacingRelatable {
    public static func constraints(first: Array<Element>, relation: ConstraintRelation, toSystemSpacing position: LayoutSpacePosition, second: LayoutAnchor<Element.AxisAnchor>, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        first.flatMap {
            Element.constraints(first: $0, relation: relation, toSystemSpacing: position, second: second, multiplier: multiplier)
        }
    }
}

@available(iOS 11, tvOS 11, macOS 11, *)
extension LayoutAnchorSystemSpacingRelatable {
    func state(_ relation: ConstraintRelation, toSystemSpacing position: LayoutSpacePosition, _ other: LayoutAnchor<AxisAnchor>) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        ConstraintModifier(subjectProvider: self) { (m, _) -> [NSLayoutConstraint] in
            Self.constraints(first: self, relation: relation, toSystemSpacing: position, second: other, multiplier: m)
        }
    }

    // MARK: After

    @discardableResult
    public func lessEqualToSystemSpacingAfter(_ other: LayoutAnchor<AxisAnchor>) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.lessEqual, toSystemSpacing: .after, other)
    }

    @discardableResult
    public func equalToSystemSpacingAfter(_ other: LayoutAnchor<AxisAnchor>) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.equal, toSystemSpacing: .after, other)
    }

    @discardableResult
    public func greaterEqualToSystemSpacingAfter(_ other: LayoutAnchor<AxisAnchor>) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.greaterEqual, toSystemSpacing: .after, other)
    }

    // MARK: Before

    @discardableResult
    public func lessEqualToSystemSpacingBefore(_ other: LayoutAnchor<AxisAnchor>) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.lessEqual, toSystemSpacing: .before, other)
    }

    @discardableResult
    public func equalToSystemSpacingBefore(_ other: LayoutAnchor<AxisAnchor>) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.equal, toSystemSpacing: .before, other)
    }

    @discardableResult
    public func greaterEqualToSystemSpacingBefore(_ other: LayoutAnchor<AxisAnchor>) -> ConstraintModifier<LayoutSystemSpacingTarget> {
        state(.greaterEqual, toSystemSpacing: .before, other)
    }
}
