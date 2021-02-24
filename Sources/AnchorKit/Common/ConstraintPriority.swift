//
//  ConstraintPriority.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/24.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public struct ConstraintPriority: ExpressibleByFloatLiteral, Hashable {
    var rawValue: Float

    public init(floatLiteral value: Float) {
        rawValue = value
    }

    public static var required: ConstraintPriority {
        return 1000.0
    }

    public static var high: ConstraintPriority {
        return 750.0
    }

    public static var medium: ConstraintPriority {
        #if os(macOS)
            return 501.0
        #else
            return 500.0
        #endif
    }

    public static var low: ConstraintPriority {
        return 250.0
    }
}

