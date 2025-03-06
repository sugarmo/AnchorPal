//
//  Typealias.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/2.
//

#if os(iOS) || os(tvOS)
    import UIKit

    public typealias LayoutView = UIView

    public typealias LayoutWindow = UIWindow

    public typealias LayoutGuide = UILayoutGuide

    public typealias LayoutPriority = UILayoutPriority

    public typealias EdgeInsets = UIEdgeInsets

    public typealias Font = UIFont
#else
    import AppKit

    public typealias LayoutView = NSView

    public typealias LayoutWindow = NSWindow

    public typealias LayoutGuide = NSLayoutGuide

    public typealias LayoutPriority = NSLayoutConstraint.Priority

    public typealias EdgeInsets = NSEdgeInsets

    public typealias Font = NSFont
#endif

public typealias DirectionalEdgeInsets = NSDirectionalEdgeInsets

public typealias ConstraintAttribute = NSLayoutConstraint.Attribute
