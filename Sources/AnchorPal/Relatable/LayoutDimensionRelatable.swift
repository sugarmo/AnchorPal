//
//  LayoutDimensionRelatable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/11.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutDimensionRelatable: ConstraintSubjectable {
    static func constraints<D>(_ receiver: Self, relation: ConstraintRelation, to other: D, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] where D: LayoutDimensionable
}

extension LayoutDimensionable {
    public static func constraints<D>(_ receiver: Self, relation: ConstraintRelation, to other: D, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] where D: LayoutDimensionable {
        let p = position(for: receiver)
        let mv = multiplier.constraintMultiplierValue
        let cv = constant.constraintConstantValue(for: p)
        return [dimension(for: receiver).constraint(relation,
                                                    to: D.dimension(for: other),
                                                    multiplier: mv,
                                                    constant: cv,
                                                    position: p)]
    }
}

extension LayoutDimension: LayoutDimensionRelatable {}
@available(iOS 10, tvOS 10, macOS 10.12, *)
extension CustomLayoutDimension: LayoutDimensionRelatable {}

extension Array: LayoutDimensionRelatable where Element: LayoutDimensionRelatable {
    public static func constraints<D>(_ receiver: Array<Element>, relation: ConstraintRelation, to other: D, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] where D: LayoutDimensionable {
        receiver.flatMap { Element.constraints($0, relation: relation, to: other, multiplier: multiplier, constant: constant) }
    }
}

extension AnchorPair: LayoutDimensionRelatable where F: LayoutDimensionRelatable, S: LayoutDimensionRelatable {
    public static func constraints<D>(_ receiver: AnchorPair<F, S>, relation: ConstraintRelation, to other: D, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] where D: LayoutDimensionable {
        F.constraints(receiver.first, relation: relation, to: other, multiplier: multiplier, constant: constant) +
            S.constraints(receiver.second, relation: relation, to: other, multiplier: multiplier, constant: constant)
    }
}

extension LayoutDimensionRelatable {
    func state<D>(_ relation: ConstraintRelation, to other: D) -> ConstraintModifier<D> where D: LayoutDimensionable {
        ConstraintModifier(subjectProvider: self) { (m, c) -> [NSLayoutConstraint] in
            Self.constraints(self, relation: relation, to: other, multiplier: m, constant: c)
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
