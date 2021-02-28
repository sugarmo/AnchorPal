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
    static func constraints(_ receiver: Self, relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint]
}

extension LayoutAnchor: LayoutSuperviewRelatable {
    public static func constraints(_ receiver: LayoutAnchor, relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        guard let superview = receiver.subjectItem.superview else {
            fatalError("\(receiver.subjectItem) has no superview at this time.")
        }

        return constraints(receiver, relation: relation, to: superview.layoutItem(for: guide), multiplier: multiplier, constant: constant)
    }
}

extension LayoutDimension: LayoutSuperviewRelatable {
    public static func constraints(_ receiver: LayoutDimension, relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        guard let superview = receiver.subjectItem.superview else {
            fatalError("\(receiver.subjectItem) has no superview at this time.")
        }

        return constraints(receiver, relation: relation, to: superview.layoutItem(for: guide), multiplier: multiplier, constant: constant)
    }
}

extension Array: LayoutSuperviewRelatable where Element: LayoutSuperviewRelatable {
    public static func constraints(_ receiver: Array, relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        receiver.flatMap {
            Element.constraints($0, relation: relation, toSuperview: guide, multiplier: multiplier, constant: constant)
        }
    }
}

extension AnchorPair: LayoutSuperviewRelatable where F: LayoutSuperviewRelatable, S: LayoutSuperviewRelatable {
    public static func constraints(_ receiver: AnchorPair<F, S>, relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        F.constraints(receiver.first, relation: relation, toSuperview: guide, multiplier: multiplier, constant: constant) +
            S.constraints(receiver.second, relation: relation, toSuperview: guide, multiplier: multiplier, constant: constant)
    }
}

extension LayoutSuperviewRelatable {
    func state(_ relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide) -> ConstraintModifier<Self> {
        ConstraintModifier(subjectProvider: self) { (m, c) -> [NSLayoutConstraint] in
            Self.constraints(self, relation: relation, toSuperview: guide, multiplier: m, constant: c)
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
