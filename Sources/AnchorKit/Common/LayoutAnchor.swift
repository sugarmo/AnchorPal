//
//  LayoutAnchor.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/10.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public struct LayoutAnchor<T> where T: SystemLayoutAnchor {
    let rawValue: T
    let attribute: AnchorAttribute
    let subjectItem: LayoutItem

    init(_ layoutAnchor: T, attribute: AnchorAttribute, subjectItem: LayoutItem) {
        rawValue = layoutAnchor
        self.attribute = attribute
        self.subjectItem = subjectItem
    }

    @available(iOS 10, tvOS 10, macOS 10.12, *)
    public func spaceAfter(_ otherAnchor: LayoutAnchor) -> CustomLayoutDimension<T> {
        CustomLayoutDimension(leading: otherAnchor.rawValue, trailing: rawValue, subjectItem: subjectItem)
    }

    @available(iOS 10, tvOS 10, macOS 10.12, *)
    public func spaceBefore(_ otherAnchor: LayoutAnchor) -> CustomLayoutDimension<T> {
        CustomLayoutDimension(leading: rawValue, trailing: otherAnchor.rawValue, subjectItem: subjectItem)
    }
}

public typealias XLayoutAnchor = LayoutAnchor<NSLayoutXAxisAnchor>
public typealias YLayoutAnchor = LayoutAnchor<NSLayoutYAxisAnchor>
