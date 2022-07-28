//
//  AnchorAttribute.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/7.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
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
            return .leading
        case .trailing, .right:
            return .trailing
        case .top, .firstBaseline:
            return .top
        case .bottom, .lastBaseline:
            return .bottom
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
