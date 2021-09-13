//
//  LayoutItem.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/2.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol LayoutItem: NSObject {
    var superview: LayoutView? { get }

    func layoutAnchor(for attribute: AnchorAttribute) -> NSObject?
}

public protocol LayoutAnchorProvider {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

public protocol BaselineAnchorProvider {
    var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
    var lastBaselineAnchor: NSLayoutYAxisAnchor { get }
}

// MARK: -

public protocol LayoutViewItem: LayoutView, LayoutItem, LayoutAnchorProvider, BaselineAnchorProvider {}

public extension LayoutViewItem {
    func layoutAnchor(for attribute: AnchorAttribute) -> NSObject? {
        switch attribute {
        case .leading:
            return leadingAnchor
        case .trailing:
            return trailingAnchor
        case .left:
            return leftAnchor
        case .right:
            return rightAnchor
        case .top:
            return topAnchor
        case .bottom:
            return bottomAnchor
        case .width:
            return widthAnchor
        case .height:
            return heightAnchor
        case .centerX:
            return centerXAnchor
        case .centerY:
            return centerYAnchor
        case .firstBaseline:
            return firstBaselineAnchor
        case .lastBaseline:
            return lastBaselineAnchor
        }
    }
}

extension LayoutView: LayoutViewItem {}

// MARK: -

public protocol LayoutGuideItem: LayoutGuide, LayoutItem, LayoutAnchorProvider {}

public extension LayoutGuideItem {
    var superview: LayoutView? {
        owningView
    }

    func layoutAnchor(for attribute: AnchorAttribute) -> NSObject? {
        switch attribute {
        case .leading:
            return leadingAnchor
        case .trailing:
            return trailingAnchor
        case .left:
            return leftAnchor
        case .right:
            return rightAnchor
        case .top:
            return topAnchor
        case .bottom:
            return bottomAnchor
        case .width:
            return widthAnchor
        case .height:
            return heightAnchor
        case .centerX:
            return centerXAnchor
        case .centerY:
            return centerYAnchor
        case .firstBaseline:
            return nil
        case .lastBaseline:
            return nil
        }
    }
}

extension LayoutGuide: LayoutGuideItem {}
