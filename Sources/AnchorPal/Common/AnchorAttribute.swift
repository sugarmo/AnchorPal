//
//  AnchorAttribute.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/7.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public enum AnchorAttribute {
    case leading
    case trailing
    case left
    case right
    case top
    case bottom
    case width
    case height
    case centerX
    case centerY
    case firstBaseline
    case lastBaseline

    var position: AnchorPosition {
        switch self {
        case .leading, .left:
            return .leadingX
        case .trailing, .right:
            return .trailingX
        case .top, .firstBaseline:
            return .leadingY
        case .bottom, .lastBaseline:
            return .trailingY
        case .width, .centerX:
            return .centerX
        case .height, .centerY:
            return .centerY
        }
    }

    func layoutAnchor<T>(of type: T.Type, from item: LayoutItem) -> T {
        guard let a = item.layoutAnchor(for: self) as? T else {
            fatalError("Can't get layoutAnchor with attibute \(self) of type \(type) from \(item).")
        }
        return a
    }
}

extension Set where Element == AnchorAttribute {
    static func += (lhs: inout Set, rhs: Element) {
        lhs.insert(rhs)
    }
}
