//
//  AnchorRelatable.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/11.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutAnchorRelatable {
    static func constraints(first: Self, relation: ConstraintRelation, second: Self, constant: ConstraintConstantValuable) -> [NSLayoutConstraint]

    static func constraints(first: Self, relation: ConstraintRelation, toSystemSpacingAfter second: Self, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint]
}

extension LayoutAnchor: LayoutAnchorRelatable {
    public static func constraints(first: LayoutAnchor<T>, relation: ConstraintRelation, second: LayoutAnchor<T>, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let cv = constant.constraintConstantValue(for: second.attribute.position)
        return [first.rawValue.constraint(relation, to: second.rawValue, constant: cv, position: second.attribute.position)]
    }

    public static func constraints(first: LayoutAnchor<T>, relation: ConstraintRelation, toSystemSpacingAfter other: LayoutAnchor<T>, multiplier: ConstraintMultiplierValuable) -> [NSLayoutConstraint] {
        let mv = multiplier.constraintMultiplierValue
        return [first.rawValue.constraint(relation, toSystemSpacingAfter: other.rawValue, multiplier: mv)]
    }
}

extension LayoutAnchorRelatable {
    func state(_ relation: ConstraintRelation, to other: Self) -> ConstraintModifier<Self> {
        ConstraintModifier { (_, c) -> [NSLayoutConstraint] in
            Self.constraints(first: self, relation: relation, second: other, constant: c)
        }
    }

    @discardableResult
    public func lessEqualTo(_ other: Self) -> ConstraintModifier<Self> {
        state(.lessEqual, to: other)
    }

    @discardableResult
    public func equalTo(_ other: Self) -> ConstraintModifier<Self> {
        state(.equal, to: other)
    }

    @discardableResult
    public func greaterEqualTo(_ other: Self) -> ConstraintModifier<Self> {
        state(.greaterEqual, to: other)
    }
}

extension LayoutAnchorRelatable {
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
