//
//  LayoutSuperviewAccessible.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/21.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutSuperviewAccessible {
    static func owningItem(for object: Self) -> LayoutItem
}

extension LayoutAnchor: LayoutSuperviewAccessible {
    public static func owningItem(for object: LayoutAnchor<T>) -> LayoutItem {
        object.owningItem
    }
}

extension LayoutDimension: LayoutSuperviewAccessible {
    public static func owningItem(for object: LayoutDimension) -> LayoutItem {
        object.owningItem
    }
}

extension Array: LayoutSuperviewAccessible where Element: LayoutSuperviewAccessible {
    public static func owningItem(for object: Array<Element>) -> LayoutItem {
        guard let first = object.first else {
            fatalError("\(object) is empty")
        }
        return Element.owningItem(for: first)
    }
}

extension AnchorPair: LayoutSuperviewAccessible where F: LayoutSuperviewAccessible {
    public static func owningItem(for object: AnchorPair<F, S>) -> LayoutItem {
        F.owningItem(for: object.first)
    }
}
