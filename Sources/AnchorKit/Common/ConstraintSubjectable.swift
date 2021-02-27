//
//  ConstraintSubjectable.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/21.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol ConstraintSubjectable {
    static func subjectItem(for object: Self) -> LayoutItem
}

extension LayoutAnchor: ConstraintSubjectable {
    public static func subjectItem(for object: LayoutAnchor<T>) -> LayoutItem {
        object.subjectItem
    }
}

extension LayoutDimension: ConstraintSubjectable {
    public static func subjectItem(for object: LayoutDimension) -> LayoutItem {
        object.subjectItem
    }
}

@available(iOS 10, tvOS 10, macOS 10.12, *)
extension CustomLayoutDimension: ConstraintSubjectable {
    public static func subjectItem(for object: CustomLayoutDimension) -> LayoutItem {
        object.subjectItem
    }
}

extension LayoutInset: ConstraintSubjectable {
    public static func subjectItem(for object: LayoutInset) -> LayoutItem {
        object.subjectItem
    }
}

extension Array: ConstraintSubjectable where Element: ConstraintSubjectable {
    public static func subjectItem(for object: Array<Element>) -> LayoutItem {
        guard let first = object.first else {
            fatalError("\(object) is empty")
        }
        return Element.subjectItem(for: first)
    }
}

extension AnchorPair: ConstraintSubjectable where F: ConstraintSubjectable {
    public static func subjectItem(for object: AnchorPair<F, S>) -> LayoutItem {
        F.subjectItem(for: object.first)
    }
}
