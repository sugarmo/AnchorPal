//
//  ConstantRelatable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/11.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif
import SwiftUI

public protocol ConstraintConstantRelatable: ConstraintSubjectable {
    static func constraints(_ receiver: Self, relation: ConstraintRelation, to constant: ConstraintConstantValuable) -> [NSLayoutConstraint]
}

extension LayoutDimensionable {
    public static func constraints(_ receiver: Self, relation: ConstraintRelation, to constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let p = position(for: receiver)
        let cv = constant.constraintConstantValue(for: p)
        return [dimension(for: receiver).constraint(relation, toConstant: cv, position: p)]
    }
}

extension LayoutDimension: ConstraintConstantRelatable {}
extension CustomLayoutDimension: ConstraintConstantRelatable {}

extension LayoutInset: ConstraintConstantRelatable {
    public static func constraints(_ receiver: LayoutInset<T>, relation: ConstraintRelation, to constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let p = receiver.attribute.position
        let cv = constant.constraintConstantValue(for: p)
        return [receiver.trailing.constraint(relation, to: receiver.leading, constant: cv, position: p)]
    }
}

extension Array: ConstraintConstantRelatable where Element: ConstraintConstantRelatable {
    public static func constraints(_ receiver: [Element], relation: ConstraintRelation, to constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        receiver.flatMap { Element.constraints($0, relation: relation, to: constant) }
    }
}

extension AnchorPair: ConstraintConstantRelatable where F: ConstraintConstantRelatable, S: ConstraintConstantRelatable {
    public static func constraints(_ receiver: AnchorPair<F, S>, relation: ConstraintRelation, to constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        F.constraints(receiver.first, relation: relation, to: constant) +
            S.constraints(receiver.second, relation: relation, to: constant)
    }
}

extension ConstraintConstantRelatable {
    func state(_ relation: ConstraintRelation, to constant: ConstraintConstantValuable) -> ConstraintModifier<Void> {
        ConstraintModifier(subjectProvider: self) { _, c -> [NSLayoutConstraint] in
            Self.constraints(self, relation: relation, to: c)
        }._constant(constant)
    }

    @discardableResult
    public func lessEqualTo(_ constant: ConstraintConstantValuable) -> ConstraintModifier<Void> {
        state(.lessEqual, to: constant)
    }

    @discardableResult
    public func equalTo(_ constant: ConstraintConstantValuable) -> ConstraintModifier<Void> {
        state(.equal, to: constant)
    }

    @discardableResult
    public func greaterEqualTo(_ constant: ConstraintConstantValuable) -> ConstraintModifier<Void> {
        state(.greaterEqual, to: constant)
    }

    @discardableResult
    public func lessEqualTo(_ constant: CGFloat) -> ConstraintModifier<Void> {
        state(.lessEqual, to: constant)
    }

    @discardableResult
    public func equalTo(_ constant: CGFloat) -> ConstraintModifier<Void> {
        state(.equal, to: constant)
    }

    @discardableResult
    public func greaterEqualTo(_ constant: CGFloat) -> ConstraintModifier<Void> {
        state(.greaterEqual, to: constant)
    }
}

extension ConstraintConstantRelatable {
    @discardableResult
    public func clamp<T>(in range: ClosedRange<T>) -> ConstraintRangeModifier where T: ConstraintConstantValuable & Comparable {
        let lower = ConstraintModifier<Void>(subjectProvider: self) { _, c -> [NSLayoutConstraint] in
            Self.constraints(self, relation: .greaterEqual, to: c)
        }._constant(range.lowerBound)

        let upper = ConstraintModifier<Void>(subjectProvider: self) { _, c -> [NSLayoutConstraint] in
            Self.constraints(self, relation: .lessEqual, to: c)
        }._constant(range.upperBound)

        return ConstraintRangeModifier(lowerBound: lower, upperBound: upper)
    }
}

extension ConstraintConstantRelatable {
    func state<T>(_ relation: ConstraintRelation, to dynamicConstant: @escaping () -> T) -> ConstraintModifier<Void> where T: ConstraintConstantValuable {
        ConstraintModifier(subjectProvider: self) { _, c -> [NSLayoutConstraint] in
            Self.constraints(self, relation: relation, to: c)
        }._constant(DynamicConstraintConstant(getter: dynamicConstant))
    }

    @discardableResult
    public func lessEqualTo<T>(_ dynamicConstant: @escaping () -> T) -> ConstraintModifier<Void> where T: ConstraintConstantValuable {
        state(.lessEqual, to: dynamicConstant)
    }

    @discardableResult
    public func equalTo<T>(_ dynamicConstant: @escaping () -> T) -> ConstraintModifier<Void> where T: ConstraintConstantValuable {
        state(.equal, to: dynamicConstant)
    }

    @discardableResult
    public func greaterEqualTo<T>(_ dynamicConstant: @escaping () -> T) -> ConstraintModifier<Void> where T: ConstraintConstantValuable {
        state(.greaterEqual, to: dynamicConstant)
    }
}

@available(iOS 13, tvOS 13, *)
extension Binding: ConstraintConstantValuable where Value: ConstraintConstantValuable {
    public func constraintConstantValue(for position: AnchorPosition) -> CGFloat {
        wrappedValue.constraintConstantValue(for: position)
    }
}

@available(iOS 13, tvOS 13, *)
extension ConstraintConstantRelatable {
    func state<T>(_ relation: ConstraintRelation, to binding: Binding<T>) -> ConstraintModifier<Void> where T: ConstraintConstantValuable {
        ConstraintModifier(subjectProvider: self) { _, c -> [NSLayoutConstraint] in
            Self.constraints(self, relation: relation, to: c)
        }._constant(binding)
    }

    @discardableResult
    public func lessEqualTo<T>(_ binding: Binding<T>) -> ConstraintModifier<Void> where T: ConstraintConstantValuable {
        state(.lessEqual, to: binding)
    }

    @discardableResult
    public func equalTo<T>(_ binding: Binding<T>) -> ConstraintModifier<Void> where T: ConstraintConstantValuable {
        state(.equal, to: binding)
    }

    @discardableResult
    public func greaterEqualTo<T>(_ binding: Binding<T>) -> ConstraintModifier<Void> where T: ConstraintConstantValuable {
        state(.greaterEqual, to: binding)
    }
}
