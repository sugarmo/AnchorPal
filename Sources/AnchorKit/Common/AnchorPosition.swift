//
//  AnchorPosition.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/22.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public enum AnchorAxis: Int {
    case horizontal = 0
    case vertical = 1
}

public enum AnchorEdge: Int {
    case leading = 1
    case center = 0
    case trailing = -1
}

public struct AnchorPosition: Equatable {
    var axis: AnchorAxis
    var edge: AnchorEdge

    static let leadingX = AnchorPosition(axis: .horizontal, edge: .leading)
    static let trailingX = AnchorPosition(axis: .horizontal, edge: .trailing)

    static let leadingY = AnchorPosition(axis: .vertical, edge: .leading)
    static let trailingY = AnchorPosition(axis: .vertical, edge: .trailing)

    static let centerX = AnchorPosition(axis: .horizontal, edge: .center)
    static let centerY = AnchorPosition(axis: .vertical, edge: .center)
}
