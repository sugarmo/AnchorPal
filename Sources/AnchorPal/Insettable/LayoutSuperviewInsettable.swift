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
    func insetFromSuperview<T>(_ keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> InsetResult
}

public extension LayoutSuperviewInsettable {
    func insetFromSuperview() -> InsetResult {
        return insetFromSuperview(\.object)
    }
}

extension LayoutAnchor: LayoutSuperviewInsettable {
    public func insetFromSuperview<T>(_ keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> InsetResult {
        guard let superview = subjectItem.superview else {
            fatalError("\(subjectItem) has no superview at this time.")
        }

        if let item = superview.anc[keyPath: keyPath] as? LayoutItem {
            return insetFrom(item)
        } else {
            fatalError("Not supported target.")
        }
    }
}

extension Array: LayoutSuperviewInsettable where Element: LayoutSuperviewInsettable {
    public func insetFromSuperview<T>(_ keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> [Element.InsetResult] {
        map { $0.insetFromSuperview(keyPath) }
    }
}

extension AnchorPair: LayoutSuperviewInsettable where F: LayoutSuperviewInsettable, S: LayoutSuperviewInsettable {
    public func insetFromSuperview<T>(_ keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> AnchorPair<F.InsetResult, S.InsetResult> {
        let first = self.first.insetFromSuperview(keyPath)
        let second = self.second.insetFromSuperview(keyPath)
        return AnchorPair<F.InsetResult, S.InsetResult>(first, second)
    }
}
