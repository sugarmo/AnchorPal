//
//  AnchorProvider.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/11.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public protocol GuideAnchorProvider: LayoutItem {
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

public protocol ViewAnchorProvider: GuideAnchorProvider {
    var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
    var lastBaselineAnchor: NSLayoutYAxisAnchor { get }
}

extension LayoutGuide: GuideAnchorProvider {}
extension LayoutView: ViewAnchorProvider {}
