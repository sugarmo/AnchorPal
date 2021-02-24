//
//  Typealias.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/2.
//

#if os(iOS) || os(tvOS)
    import UIKit

    public typealias LayoutView = UIView

    public typealias LayoutGuide = UILayoutGuide

    public typealias LayoutPriority = UILayoutPriority

    public typealias EdgeInsets = UIEdgeInsets
#else
    import AppKit

    public typealias LayoutView = NSView

    public typealias LayoutGuide = NSLayoutGuide

    public typealias LayoutPriority = NSLayoutConstraint.Priority

    public typealias EdgeInsets = NSEdgeInsets
#endif

@available(iOS 11, tvOS 11, macOS 10.15, *)
public typealias DirectionalEdgeInsets = NSDirectionalEdgeInsets

public typealias ConstraintAttribute = NSLayoutConstraint.Attribute
