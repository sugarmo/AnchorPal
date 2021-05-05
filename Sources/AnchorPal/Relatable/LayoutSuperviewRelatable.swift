//
//  LayoutSuperviewRelatable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/12.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutSuperviewRelatable: LayoutItemRelatable {
    static func constraints<T>(_ receiver: Self, relation: ConstraintRelation, toSuperview keyPath: KeyPath<AnchorDSL<LayoutView>, T>, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint]
}

extension LayoutAnchor: LayoutSuperviewRelatable {
    public static func constraints<T>(_ receiver: LayoutAnchor, relation: ConstraintRelation, toSuperview keyPath: KeyPath<AnchorDSL<LayoutView>, T>, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        guard let superview = receiver.subjectItem.superview else {
            fatalError("\(receiver.subjectItem) has no superview at this time.")
        }

        let object = superview.anc[keyPath: keyPath]

        if let item = object as? LayoutItem {
            return constraints(receiver, relation: relation, to: item, multiplier: multiplier, constant: constant)
        } else if let anchor = object as? LayoutAnchor {
            return constraints(receiver, relation: relation, to: anchor, constant: constant)
        } else {
            fatalError("Not supported target.")
        }
    }
}

extension LayoutDimension: LayoutSuperviewRelatable {
    public static func constraints<T>(_ receiver: LayoutDimension, relation: ConstraintRelation, toSuperview keyPath: KeyPath<AnchorDSL<LayoutView>, T>, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        guard let superview = receiver.subjectItem.superview else {
            fatalError("\(receiver.subjectItem) has no superview at this time.")
        }

        let object = superview.anc[keyPath: keyPath]

        if let item = object as? LayoutItem {
            return constraints(receiver, relation: relation, to: item, multiplier: multiplier, constant: constant)
        } else if let dimension = object as? LayoutDimension {
            return constraints(receiver, relation: relation, to: dimension, multiplier: multiplier, constant: constant)
        } else {
            fatalError("Not supported target.")
        }
    }
}

extension Array: LayoutSuperviewRelatable where Element: LayoutSuperviewRelatable {
    public static func constraints<T>(_ receiver: Array, relation: ConstraintRelation, toSuperview keyPath: KeyPath<AnchorDSL<LayoutView>, T>, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        receiver.flatMap {
            Element.constraints($0, relation: relation, toSuperview: keyPath, multiplier: multiplier, constant: constant)
        }
    }
}

extension AnchorPair: LayoutSuperviewRelatable where F: LayoutSuperviewRelatable, S: LayoutSuperviewRelatable {
    public static func constraints<T>(_ receiver: AnchorPair<F, S>, relation: ConstraintRelation, toSuperview keyPath: KeyPath<AnchorDSL<LayoutView>, T>, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        F.constraints(receiver.first, relation: relation, toSuperview: keyPath, multiplier: multiplier, constant: constant) +
            S.constraints(receiver.second, relation: relation, toSuperview: keyPath, multiplier: multiplier, constant: constant)
    }
}

extension LayoutSuperviewRelatable {
    func state<T>(_ relation: ConstraintRelation, toSuperview keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> ConstraintModifier<Self> {
        ConstraintModifier(subjectProvider: self) { (m, c) -> [NSLayoutConstraint] in
            Self.constraints(self, relation: relation, toSuperview: keyPath, multiplier: m, constant: c)
        }
    }

    @discardableResult
    public func lessEqualToSuperview() -> ConstraintModifier<Self> {
        state(.lessEqual, toSuperview: \.object)
    }

    @discardableResult
    public func equalToSuperview() -> ConstraintModifier<Self> {
        state(.equal, toSuperview: \.object)
    }

    @discardableResult
    public func greaterEqualToSuperview() -> ConstraintModifier<Self> {
        state(.greaterEqual, toSuperview: \.object)
    }

    @discardableResult
    public func lessEqualToSuperview<T>(_ keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> ConstraintModifier<Self> {
        state(.lessEqual, toSuperview: keyPath)
    }

    @discardableResult
    public func equalToSuperview<T>(_ keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> ConstraintModifier<Self> {
        state(.equal, toSuperview: keyPath)
    }

    @discardableResult
    public func greaterEqualToSuperview<T>(_ keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> ConstraintModifier<Self> {
        state(.greaterEqual, toSuperview: keyPath)
    }
}
