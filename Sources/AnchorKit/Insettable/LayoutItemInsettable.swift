//
//  LayoutItemInsettable.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/14.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutItemInsettable {
    associatedtype InsetResult

    func insetFrom(_ item: LayoutItem) -> InsetResult
}

extension LayoutAnchor: LayoutItemInsettable {
    public func insetFrom(_ item: LayoutItem) -> LayoutInset<T> {
        let other = attribute.layoutAnchor(of: T.self, from: item)

        if attribute.position.edge.rawValue < 0 {
            return LayoutInset(leading: rawValue, trailing: other, attribute: attribute, subjectItem: subjectItem)
        } else {
            return LayoutInset(leading: other, trailing: rawValue, attribute: attribute, subjectItem: subjectItem)
        }
    }
}

extension Array: LayoutItemInsettable where Element: LayoutItemInsettable {
    public func insetFrom(_ item: LayoutItem) -> [Element.InsetResult] {
        compactMap { $0.insetFrom(item) }
    }
}

extension AnchorPair: LayoutItemInsettable where F: LayoutItemInsettable, S: LayoutItemInsettable {
    public func insetFrom(_ item: LayoutItem) -> AnchorPair<F.InsetResult, S.InsetResult> {
        let first = self.first.insetFrom(item)
        let second = self.second.insetFrom(item)
        return AnchorPair<F.InsetResult, S.InsetResult>(first, second)
    }
}
