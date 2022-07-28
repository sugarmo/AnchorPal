//
//  CGFloatConvertible.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/2.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public protocol CGFloatConvertible {
    var cgFloatValue: CGFloat { get }
}

extension Float: CGFloatConvertible {
    public var cgFloatValue: CGFloat {
        CGFloat(self)
    }
}

extension Double: CGFloatConvertible {
    public var cgFloatValue: CGFloat {
        CGFloat(self)
    }
}

extension UInt: CGFloatConvertible {
    public var cgFloatValue: CGFloat {
        CGFloat(self)
    }
}

extension Int: CGFloatConvertible {
    public var cgFloatValue: CGFloat {
        CGFloat(self)
    }
}
