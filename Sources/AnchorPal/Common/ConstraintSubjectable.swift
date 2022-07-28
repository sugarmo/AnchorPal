//
//  ConstraintSubjectable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/21.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public protocol ConstraintSubjectable {
    static func subjectItems(for object: Self) -> [LayoutItem]
}

extension LayoutAnchor: ConstraintSubjectable {
    public static func subjectItems(for object: LayoutAnchor<T>) -> [LayoutItem] {
        [object.subjectItem]
    }
}

extension LayoutDimension: ConstraintSubjectable {
    public static func subjectItems(for object: LayoutDimension) -> [LayoutItem] {
        [object.subjectItem]
    }
}

@available(iOS 10, tvOS 10, macOS 10.12, *)
extension CustomLayoutDimension: ConstraintSubjectable {
    public static func subjectItems(for object: CustomLayoutDimension) -> [LayoutItem] {
        [object.subjectItem]
    }
}

extension LayoutInset: ConstraintSubjectable {
    public static func subjectItems(for object: LayoutInset) -> [LayoutItem] {
        [object.subjectItem]
    }
}

extension Array: ConstraintSubjectable where Element: ConstraintSubjectable {
    public static func subjectItems(for object: [Element]) -> [LayoutItem] {
        object.flatMap { Element.subjectItems(for: $0) }
    }
}

extension AnchorPair: ConstraintSubjectable where F: ConstraintSubjectable, S: ConstraintSubjectable {
    public static func subjectItems(for object: AnchorPair<F, S>) -> [LayoutItem] {
        F.subjectItems(for: object.first) + S.subjectItems(for: object.second)
    }
}
