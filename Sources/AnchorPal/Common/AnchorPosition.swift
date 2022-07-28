//
//  AnchorPosition.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/22.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public enum AnchorAxis {
    public enum Location: Comparable {
        case min
        case mid
        case max
    }

    case horizontal
    case vertical
}

public struct AnchorPosition: Equatable {
    var axis: AnchorAxis
    var location: AnchorAxis.Location

    static let leading = AnchorPosition(axis: .horizontal, location: .min)
    static let trailing = AnchorPosition(axis: .horizontal, location: .max)

    static let top = AnchorPosition(axis: .vertical, location: .min)
    static let bottom = AnchorPosition(axis: .vertical, location: .max)

    static let centerX = AnchorPosition(axis: .horizontal, location: .mid)
    static let centerY = AnchorPosition(axis: .vertical, location: .mid)
}
