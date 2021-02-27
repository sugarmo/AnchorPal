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
    static func constraints(first: Self, relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint]
}

extension LayoutAnchor: LayoutSuperviewRelatable {
    public static func constraints(first: LayoutAnchor, relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        guard let superview = first.subjectItem.superview else {
            fatalError("\(first.subjectItem) has no superview at this time.")
        }

        return constraints(first: first, relation: relation, second: superview.layoutItem(for: guide), multiplier: multiplier, constant: constant)
    }
}

extension LayoutDimension: LayoutSuperviewRelatable {
    public static func constraints(first: LayoutDimension, relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        guard let superview = first.subjectItem.superview else {
            fatalError("\(first.subjectItem) has no superview at this time.")
        }

        return constraints(first: first, relation: relation, second: superview.layoutItem(for: guide), multiplier: multiplier, constant: constant)
    }
}

extension Array: LayoutSuperviewRelatable where Element: LayoutSuperviewRelatable {
    public static func constraints(first: Array, relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        first.flatMap {
            Element.constraints(first: $0, relation: relation, toSuperview: guide, multiplier: multiplier, constant: constant)
        }
    }
}

extension AnchorPair: LayoutSuperviewRelatable where F: LayoutSuperviewRelatable, S: LayoutSuperviewRelatable {
    public static func constraints(first: AnchorPair<F, S>, relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        F.constraints(first: first.first, relation: relation, toSuperview: guide, multiplier: multiplier, constant: constant) +
            S.constraints(first: first.second, relation: relation, toSuperview: guide, multiplier: multiplier, constant: constant)
    }
}

extension LayoutSuperviewRelatable {
    func state(_ relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide) -> ConstraintModifier<Self> {
        ConstraintModifier(subjectProvider: self) { (m, c) -> [NSLayoutConstraint] in
            Self.constraints(first: self, relation: relation, toSuperview: guide, multiplier: m, constant: c)
        }
    }

    @discardableResult
    public func lessEqualToSuperview(_ guide: LayoutSuperviewGuide = .edges) -> ConstraintModifier<Self> {
        state(.lessEqual, toSuperview: guide)
    }

    @discardableResult
    public func equalToSuperview(_ guide: LayoutSuperviewGuide = .edges) -> ConstraintModifier<Self> {
        state(.equal, toSuperview: guide)
    }

    @discardableResult
    public func greaterEqualToSuperview(_ guide: LayoutSuperviewGuide = .edges) -> ConstraintModifier<Self> {
        state(.greaterEqual, toSuperview: guide)
    }
}
