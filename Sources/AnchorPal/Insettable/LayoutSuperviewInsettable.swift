//
//  LayoutSuperviewInsettable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/14.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutSuperviewInsettable: ConstraintSubjectable, LayoutItemInsettable {}

extension LayoutSuperviewInsettable {
    public func insetFromSuperview(_ guide: LayoutSuperviewGuide = .edges) -> InsetResult {
        let item = Self.subjectItem(for: self)
        guard let superview = item.superview else {
            fatalError("\(item) has no superview at this time.")
        }

        return insetFrom(superview.layoutItem(for: guide))
    }
}

extension LayoutAnchor: LayoutSuperviewInsettable {}

extension Array: LayoutSuperviewInsettable where Element: LayoutSuperviewInsettable {}

extension AnchorPair: LayoutSuperviewInsettable where F: LayoutSuperviewInsettable, S: LayoutItemInsettable {}

