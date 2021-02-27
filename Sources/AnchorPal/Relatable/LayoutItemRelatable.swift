//
//  LayoutItemRelatable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/11.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutItemRelatable: ConstraintSubjectable {
    static func constraints(first: Self, relation: ConstraintRelation, second: LayoutItem, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint]
}

extension LayoutAnchor: LayoutItemRelatable {
    public static func constraints(first: LayoutAnchor<T>, relation: ConstraintRelation, second: LayoutItem, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let a = first.attribute.layoutAnchor(of: T.self, from: second)
        let cv = constant.constraintConstantValue(for: first.attribute.position)
        return [first.rawValue.constraint(relation, to: a, constant: cv, position: first.attribute.position)]
    }
}

extension LayoutDimension: LayoutItemRelatable {
    public static func constraints(first: LayoutDimension, relation: ConstraintRelation, second: LayoutItem, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let d = first.attribute.layoutAnchor(of: NSLayoutDimension.self, from: second)
        let mv = multiplier.constraintMultiplierValue
        let cv = constant.constraintConstantValue(for: first.attribute.position)
        return [dimension(for: first).constraint(relation,
                                                to: d,
                                                multiplier: mv,
                                                constant: cv,
                                                position: first.attribute.position)]
    }
}

extension Array: LayoutItemRelatable where Element: LayoutItemRelatable {
    public static func constraints(first: Array<Element>, relation: ConstraintRelation, second: LayoutItem, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        first.flatMap { Element.constraints(first: $0, relation: relation, second: second, multiplier: multiplier, constant: constant) }
    }
}

extension AnchorPair: LayoutItemRelatable where F: LayoutItemRelatable, S: LayoutItemRelatable {
    public static func constraints(first: AnchorPair<F, S>, relation: ConstraintRelation, second: LayoutItem, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        F.constraints(first: first.first, relation: relation, second: second, multiplier: multiplier, constant: constant) +
            S.constraints(first: first.second, relation: relation, second: second, multiplier: multiplier, constant: constant)
    }
}

extension LayoutItemRelatable {
    func state(_ relation: ConstraintRelation, to other: LayoutItem) -> ConstraintModifier<Self> {
        ConstraintModifier(subjectProvider: self) { (m, c) -> [NSLayoutConstraint] in
            Self.constraints(first: self, relation: relation, second: other, multiplier: m, constant: c)
        }
    }

    @discardableResult
    public func lessEqualTo(_ other: LayoutItem) -> ConstraintModifier<Self> {
        state(.lessEqual, to: other)
    }

    @discardableResult
    public func equalTo(_ other: LayoutItem) -> ConstraintModifier<Self> {
        state(.equal, to: other)
    }

    @discardableResult
    public func greaterEqualTo(_ other: LayoutItem) -> ConstraintModifier<Self> {
        state(.greaterEqual, to: other)
    }
}
