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

public protocol LayoutSuperviewInsettable: ConstraintSubjectable, LayoutItemInsettable {
    func insetFromSuperview(_ guide: LayoutSuperviewGuide) -> InsetResult
}

extension LayoutAnchor: LayoutSuperviewInsettable {
    public func insetFromSuperview(_ guide: LayoutSuperviewGuide = .edges) -> InsetResult {
        guard let superview = subjectItem.superview else {
            fatalError("\(subjectItem) has no superview at this time.")
        }

        return insetFrom(superview.layoutItem(for: guide))
    }
}

extension Array: LayoutSuperviewInsettable where Element: LayoutSuperviewInsettable {
    public func insetFromSuperview(_ guide: LayoutSuperviewGuide) -> [Element.InsetResult] {
        map { $0.insetFromSuperview(guide) }
    }
}

extension AnchorPair: LayoutSuperviewInsettable where F: LayoutSuperviewInsettable, S: LayoutSuperviewInsettable {
    public func insetFromSuperview(_ guide: LayoutSuperviewGuide) -> AnchorPair<F.InsetResult, S.InsetResult> {
        let first = self.first.insetFromSuperview(guide)
        let second = self.second.insetFromSuperview(guide)
        return AnchorPair<F.InsetResult, S.InsetResult>(first, second)
    }
}
