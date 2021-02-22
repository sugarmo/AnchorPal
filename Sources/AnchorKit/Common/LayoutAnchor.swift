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
    let owningItem: LayoutItem

    init(_ layoutAnchor: T, attribute: AnchorAttribute, owningItem: LayoutItem) {
        rawValue = layoutAnchor
        self.attribute = attribute
        self.owningItem = owningItem
    }

    public func spaceAfter(_ otherAnchor: LayoutAnchor) -> CustomLayoutDimension<T> {
        CustomLayoutDimension(leading: otherAnchor.rawValue, trailing: rawValue)
    }
}

public typealias XLayoutAnchor = LayoutAnchor<NSLayoutXAxisAnchor>
public typealias YLayoutAnchor = LayoutAnchor<NSLayoutYAxisAnchor>
