//
//  LayoutDimensionRelatable.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/11.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutDimensionRelatable {
    static func constraints<D>(first: Self, relation: ConstraintRelation, second: D, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] where D: LayoutDimensionable
}

extension LayoutDimensionable {
    public static func constraints<D>(first: Self, relation: ConstraintRelation, second: D, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] where D: LayoutDimensionable {
        let p = position(for: first)
        let mv = multiplier.constraintMultiplierValue
        let cv = constant.constraintConstantValue(for: p)
        return [dimension(for: first).constraint(relation,
                                                 to: D.dimension(for: second),
                                                 multiplier: mv,
                                                 constant: cv,
                                                 position: p)]
    }
}

extension LayoutDimension: LayoutDimensionRelatable {}
@available(iOS 10, tvOS 10, macOS 10.12, *)
extension CustomLayoutDimension: LayoutDimensionRelatable {}

extension Array: LayoutDimensionRelatable where Element: LayoutDimensionRelatable {
    public static func constraints<D>(first: Array<Element>, relation: ConstraintRelation, second: D, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] where D: LayoutDimensionable {
        first.flatMap { Element.constraints(first: $0, relation: relation, second: second, multiplier: multiplier, constant: constant) }
    }
}

extension AnchorPair: LayoutDimensionRelatable where F: LayoutDimensionRelatable, S: LayoutDimensionRelatable {
    public static func constraints<D>(first: AnchorPair<F, S>, relation: ConstraintRelation, second: D, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] where D: LayoutDimensionable {
        F.constraints(first: first.first, relation: relation, second: second, multiplier: multiplier, constant: constant) +
            S.constraints(first: first.second, relation: relation, second: second, multiplier: multiplier, constant: constant)
    }
}

extension LayoutDimensionRelatable {
    func state<D>(_ relation: ConstraintRelation, to other: D) -> ConstraintModifier<D> where D: LayoutDimensionable {
        ConstraintModifier { (m, c) -> [NSLayoutConstraint] in
            Self.constraints(first: self, relation: relation, second: other, multiplier: m, constant: c)
        }
    }

    @discardableResult
    public func lessEqualTo<D>(_ other: D) -> ConstraintModifier<D> where D: LayoutDimensionable {
        state(.lessEqual, to: other)
    }

    @discardableResult
    public func equalTo<D>(_ other: D) -> ConstraintModifier<D> where D: LayoutDimensionable {
        state(.equal, to: other)
    }

    @discardableResult
    public func greaterEqualTo<D>(_ other: D) -> ConstraintModifier<D> where D: LayoutDimensionable {
        state(.greaterEqual, to: other)
    }
}
