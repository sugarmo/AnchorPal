//
//  LayoutAnchor.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/10.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public struct LayoutAnchor<RawAnchor> where RawAnchor: SystemLayoutAnchor {
    let rawValue: RawAnchor
    let attribute: AnchorAttribute
    let subjectItem: LayoutItem

    init(_ layoutAnchor: RawAnchor, attribute: AnchorAttribute, subjectItem: LayoutItem) {
        rawValue = layoutAnchor
        self.attribute = attribute
        self.subjectItem = subjectItem
    }

    public func spaceAfter(_ otherAnchor: LayoutAnchor) -> CustomLayoutDimension<RawAnchor> {
        CustomLayoutDimension(leading: otherAnchor.rawValue, trailing: rawValue, subjectItem: subjectItem)
    }

    public func spaceBefore(_ otherAnchor: LayoutAnchor) -> CustomLayoutDimension<RawAnchor> {
        CustomLayoutDimension(leading: rawValue, trailing: otherAnchor.rawValue, subjectItem: subjectItem)
    }
}

public typealias XLayoutAnchor = LayoutAnchor<NSLayoutXAxisAnchor>
public typealias YLayoutAnchor = LayoutAnchor<NSLayoutYAxisAnchor>
