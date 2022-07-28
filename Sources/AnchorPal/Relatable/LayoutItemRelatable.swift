//
//  LayoutItemRelatable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/11.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public protocol LayoutItemRelatable: ConstraintSubjectable {
    static func constraints(_ receiver: Self, relation: ConstraintRelation, to other: LayoutItem, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint]
}

extension LayoutAnchor: LayoutItemRelatable {
    public static func constraints(_ receiver: LayoutAnchor<T>, relation: ConstraintRelation, to other: LayoutItem, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let a = receiver.attribute.layoutAnchor(of: T.self, from: other)
        let cv = constant.constraintConstantValue(for: receiver.attribute.position)
        return [receiver.rawValue.constraint(relation, to: a, constant: cv, position: receiver.attribute.position)]
    }
}

extension LayoutDimension: LayoutItemRelatable {
    public static func constraints(_ receiver: LayoutDimension, relation: ConstraintRelation, to other: LayoutItem, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let d = receiver.attribute.layoutAnchor(of: NSLayoutDimension.self, from: other)
        let mv = multiplier.constraintMultiplierValue
        let cv = constant.constraintConstantValue(for: receiver.attribute.position)
        return [dimension(for: receiver).constraint(relation,
                                                    to: d,
                                                    multiplier: mv,
                                                    constant: cv,
                                                    position: receiver.attribute.position)]
    }
}

extension Array: LayoutItemRelatable where Element: LayoutItemRelatable {
    public static func constraints(_ receiver: [Element], relation: ConstraintRelation, to other: LayoutItem, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        receiver.flatMap { Element.constraints($0, relation: relation, to: other, multiplier: multiplier, constant: constant) }
    }
}

extension AnchorPair: LayoutItemRelatable where F: LayoutItemRelatable, S: LayoutItemRelatable {
    public static func constraints(_ receiver: AnchorPair<F, S>, relation: ConstraintRelation, to other: LayoutItem, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        F.constraints(receiver.first, relation: relation, to: other, multiplier: multiplier, constant: constant) +
            S.constraints(receiver.second, relation: relation, to: other, multiplier: multiplier, constant: constant)
    }
}

extension LayoutItemRelatable {
    func state(_ relation: ConstraintRelation, to other: LayoutItem) -> ConstraintModifier<Self> {
        ConstraintModifier(subjectProvider: self) { m, c -> [NSLayoutConstraint] in
            Self.constraints(self, relation: relation, to: other, multiplier: m, constant: c)
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
