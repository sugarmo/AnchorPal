//
//  LayoutItem.swift
//  AnchorKit
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

    func ignoreAutoresizingMask()

    func layoutAnchor(for attribute: AnchorAttribute) -> NSObject?
}

extension LayoutView: LayoutItem {
    public func layoutAnchor(for attribute: AnchorAttribute) -> NSObject? {
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

    public func ignoreAutoresizingMask() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension LayoutGuide: LayoutItem {
    public var superview: LayoutView? {
        owningView
    }

    public func layoutAnchor(for attribute: AnchorAttribute) -> NSObject? {
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

    public func ignoreAutoresizingMask() {
        //
    }
}
