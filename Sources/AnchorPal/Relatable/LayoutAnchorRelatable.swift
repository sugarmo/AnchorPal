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
    associatedtype Other

    static func constraints(_ receiver: Self, relation: ConstraintRelation, to other: Other, constant: ConstraintConstantValuable) -> [NSLayoutConstraint]
}

extension LayoutAnchor: LayoutAnchorRelatable {
    public static func constraints(_ receiver: LayoutAnchor<T>, relation: ConstraintRelation, to other: LayoutAnchor<T>, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let cv = constant.constraintConstantValue(for: other.attribute.position)
        return [receiver.rawValue.constraint(relation, to: other.rawValue, constant: cv, position: other.attribute.position)]
    }
}

extension Array: LayoutAnchorRelatable where Element: LayoutAnchorRelatable {
    public static func constraints(_ receiver: [Element], relation: ConstraintRelation, to other: Element.Other, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        receiver.flatMap {
            Element.constraints($0, relation: relation, to: other, constant: constant)
        }
    }
}

extension AnchorPair: LayoutAnchorRelatable where F: LayoutAnchorRelatable, S: LayoutAnchorRelatable {
    public static func constraints(_ receiver: AnchorPair, relation: ConstraintRelation, to other: AnchorPair<F.Other, S.Other>, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        F.constraints(receiver.first, relation: relation, to: other.first, constant: constant) +
            S.constraints(receiver.second, relation: relation, to: other.second, constant: constant)
    }
}

extension LayoutAnchorRelatable {
    func state(_ relation: ConstraintRelation, to other: Other) -> ConstraintModifier<Self> {
        ConstraintModifier(subjectProvider: self) { _, c -> [NSLayoutConstraint] in
            Self.constraints(self, relation: relation, to: other, constant: c)
        }
    }

    @discardableResult
    public func lessEqualTo(_ other: Other) -> ConstraintModifier<Self> {
        state(.lessEqual, to: other)
    }

    @discardableResult
    public func equalTo(_ other: Other) -> ConstraintModifier<Self> {
        state(.equal, to: other)
    }

    @discardableResult
    public func greaterEqualTo(_ other: Other) -> ConstraintModifier<Self> {
        state(.greaterEqual, to: other)
    }
}
