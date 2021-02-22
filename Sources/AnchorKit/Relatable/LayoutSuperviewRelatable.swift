//
//  LayoutSuperviewRelatable.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/12.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutSuperviewRelatable: LayoutSuperviewAccessible, LayoutItemRelatable {}

extension LayoutSuperviewRelatable {
    static func constraints(first: Self, relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide, multiplier: ConstraintMultiplierValuable, constant: ConstraintConstantValuable) -> [NSLayoutConstraint] {
        let item = owningItem(for: first)
        guard let superview = item.superview else {
            fatalError("\(item) has no superview at this time.")
        }

        return constraints(first: first, relation: relation, second: superview.layoutItem(for: guide), multiplier: multiplier, constant: constant)
    }
}

extension LayoutAnchor: LayoutSuperviewRelatable {}

extension LayoutDimension: LayoutSuperviewRelatable {}

extension Array: LayoutSuperviewRelatable where Element: LayoutSuperviewRelatable {}

extension AnchorPair: LayoutSuperviewRelatable where F: LayoutSuperviewRelatable, S: LayoutItemRelatable {}

extension LayoutSuperviewRelatable {
    func state(_ relation: ConstraintRelation, toSuperview guide: LayoutSuperviewGuide) -> ConstraintModifier<Self> {
        ConstraintModifier { (m, c) -> [NSLayoutConstraint] in
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
