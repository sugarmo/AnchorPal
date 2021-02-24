//
//  ConstantRelatable.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/11.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol ConstraintConstantRelatable {
    static func constraints(first: Self, relation: ConstraintRelation, constant: ConstraintConstantValuable) -> [NSLayoutConstraint]
}

extension LayoutDimensionable {
    public static func constraints(first: Self, relation: ConstraintRelation, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let p = position(for: first)
        let cv = constant.constraintConstantValue(for: p)
        return [dimension(for: first).constraint(relation, toConstant: cv, position: p)]
    }
}

extension LayoutDimension: ConstraintConstantRelatable {}
@available(iOS 10, tvOS 10, macOS 10.12, *)
extension CustomLayoutDimension: ConstraintConstantRelatable {}

extension LayoutInset: ConstraintConstantRelatable {
    public static func constraints(first: LayoutInset<T>, relation: ConstraintRelation, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let p = first.attribute.position
        let cv = constant.constraintConstantValue(for: p)
        return [first.trailing.constraint(relation, to: first.leading, constant: cv, position: p)]
    }
}

extension Array: ConstraintConstantRelatable where Element: ConstraintConstantRelatable {
    public static func constraints(first: Array<Element>, relation: ConstraintRelation, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        first.flatMap { Element.constraints(first: $0, relation: relation, constant: constant) }
    }
}

extension AnchorPair: ConstraintConstantRelatable where F: ConstraintConstantRelatable, S: ConstraintConstantRelatable {
    public static func constraints(first: AnchorPair<F, S>, relation: ConstraintRelation, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        F.constraints(first: first.first, relation: relation, constant: constant) +
            S.constraints(first: first.second, relation: relation, constant: constant)
    }
}

extension ConstraintConstantRelatable {
    func state(_ relation: ConstraintRelation, to constant: ConstraintConstantValuable) -> ConstraintModifier<ConstraintConstantTarget> {
        ConstraintModifier { (_, c) -> [NSLayoutConstraint] in
            Self.constraints(first: self, relation: relation, constant: c)
        }._constant(constant)
    }

    @discardableResult
    public func lessEqualTo(_ constant: ConstraintConstantValuable) -> ConstraintModifier<ConstraintConstantTarget> {
        state(.lessEqual, to: constant)
    }

    @discardableResult
    public func equalTo(_ constant: ConstraintConstantValuable) -> ConstraintModifier<ConstraintConstantTarget> {
        state(.equal, to: constant)
    }

    @discardableResult
    public func greaterEqualTo(_ constant: ConstraintConstantValuable) -> ConstraintModifier<ConstraintConstantTarget> {
        state(.greaterEqual, to: constant)
    }
}

extension ConstraintConstantRelatable {
    func state(_ relation: ConstraintRelation, to getter: @escaping DynamicConstraintConstant.Getter) -> ConstraintModifier<ConstraintConstantTarget> {
        ConstraintModifier { (_, c) -> [NSLayoutConstraint] in
            Self.constraints(first: self, relation: relation, constant: c)
        }._constant(DynamicConstraintConstant(getter: getter))
    }

    @discardableResult
    public func lessEqualTo(_ getter: @escaping DynamicConstraintConstant.Getter) -> ConstraintModifier<ConstraintConstantTarget> {
        state(.lessEqual, to: getter)
    }

    @discardableResult
    public func equalTo(_ getter: @escaping DynamicConstraintConstant.Getter) -> ConstraintModifier<ConstraintConstantTarget> {
        state(.equal, to: getter)
    }

    @discardableResult
    public func greaterEqualTo(_ getter: @escaping DynamicConstraintConstant.Getter) -> ConstraintModifier<ConstraintConstantTarget> {
        state(.greaterEqual, to: getter)
    }
}
