//
//  AnchorRelatable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/11.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutAnchorRelatable: ConstraintSubjectable {
    associatedtype AxisAnchor: SystemLayoutAnchor

    static func constraints(first: Self, relation: ConstraintRelation, second: LayoutAnchor<AxisAnchor>, constant: ConstraintConstantValuable) -> [NSLayoutConstraint]
}

extension LayoutAnchor: LayoutAnchorRelatable {
    public static func constraints(first: LayoutAnchor<T>, relation: ConstraintRelation, second: LayoutAnchor<T>, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let cv = constant.constraintConstantValue(for: second.attribute.position)
        return [first.rawValue.constraint(relation, to: second.rawValue, constant: cv, position: second.attribute.position)]
    }
}

extension Array: LayoutAnchorRelatable where Element: LayoutAnchorRelatable {
    public static func constraints(first: Array<Element>, relation: ConstraintRelation, second: LayoutAnchor<Element.AxisAnchor>, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        first.flatMap {
            Element.constraints(first: $0, relation: relation, second: second, constant: constant)
        }
    }
}

extension LayoutAnchorRelatable {
    func state(_ relation: ConstraintRelation, to other: LayoutAnchor<AxisAnchor>) -> ConstraintModifier<Self> {
        ConstraintModifier(subjectProvider: self) { (_, c) -> [NSLayoutConstraint] in
            Self.constraints(first: self, relation: relation, second: other, constant: c)
        }
    }

    @discardableResult
    public func lessEqualTo(_ other: LayoutAnchor<AxisAnchor>) -> ConstraintModifier<Self> {
        state(.lessEqual, to: other)
    }

    @discardableResult
    public func equalTo(_ other: LayoutAnchor<AxisAnchor>) -> ConstraintModifier<Self> {
        state(.equal, to: other)
    }

    @discardableResult
    public func greaterEqualTo(_ other: LayoutAnchor<AxisAnchor>) -> ConstraintModifier<Self> {
        state(.greaterEqual, to: other)
    }
}
