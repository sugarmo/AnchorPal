//
//  Dimension.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/13.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutDimensionable {
    static func dimension(for object: Self) -> NSLayoutDimension
    static func position(for object: Self) -> AnchorPosition
}

public struct LayoutDimension: LayoutDimensionable {
    let rawValue: NSLayoutDimension
    let attribute: AnchorAttribute
    let subjectItem: LayoutItem

    init(_ rawValue: NSLayoutDimension, attribute: AnchorAttribute, subjectItem: LayoutItem) {
        self.rawValue = rawValue
        self.attribute = attribute
        self.subjectItem = subjectItem
    }

    public static func dimension(for object: LayoutDimension) -> NSLayoutDimension {
        object.rawValue
    }

    public static func position(for object: LayoutDimension) -> AnchorPosition {
        object.attribute.position
    }
}

@available(iOS 10, tvOS 10, macOS 10.12, *)
public struct CustomLayoutDimension<T>: LayoutDimensionable where T: SystemLayoutAnchor {
    let leading: T
    let trailing: T
    let subjectItem: LayoutItem

    var position: AnchorPosition {
        T.customDimensionPosition
    }

    var dimension: NSLayoutDimension {
        leading.anchorWithOffset(to: trailing)
    }

    public static func dimension(for object: CustomLayoutDimension<T>) -> NSLayoutDimension {
        object.dimension
    }

    public static func position(for object: CustomLayoutDimension<T>) -> AnchorPosition {
        object.position
    }
}

public struct LayoutInset<T> where T: SystemLayoutAnchor {
    let leading: T
    let trailing: T
    let attribute: AnchorAttribute
    let subjectItem: LayoutItem
}
