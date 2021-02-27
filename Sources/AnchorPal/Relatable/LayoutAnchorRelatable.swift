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
    static func constraints(first: Self, relation: ConstraintRelation, second: Self, constant: ConstraintConstantValuable) -> [NSLayoutConstraint]
}

extension LayoutAnchor: LayoutAnchorRelatable {
    public static func constraints(first: LayoutAnchor<T>, relation: ConstraintRelation, second: LayoutAnchor<T>, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let cv = constant.constraintConstantValue(for: second.attribute.position)
        return [first.rawValue.constraint(relation, to: second.rawValue, constant: cv, position: second.attribute.position)]
    }
}

// extension Array: LayoutAnchorRelatable where Element: LayoutAnchorRelatable {
//    public static func constraints(first: Array<Element>, relation: ConstraintRelation, second: Array<Element>, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
//        first.enumerated().flatMap { (index, element) -> [NSLayoutConstraint] in
//            Element.constraints(first: element, relation: relation, second: second[index], constant: constant)
//        }
//    }
// }
//
// extension AnchorPair: LayoutAnchorRelatable where F: LayoutAnchorRelatable, S: LayoutAnchorRelatable {
//    public static func constraints(first: AnchorPair<F, S>, relation: ConstraintRelation, second: AnchorPair<F, S>, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
//        F.constraints(first: first.first, relation: relation, second: second.first, constant: constant) +
//            S.constraints(first: first.second, relation: relation, second: second.second, constant: constant)
//    }
// }

extension LayoutAnchorRelatable {
    func state(_ relation: ConstraintRelation, to other: Self) -> ConstraintModifier<Self> {
        ConstraintModifier(subjectProvider: self) { (_, c) -> [NSLayoutConstraint] in
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
