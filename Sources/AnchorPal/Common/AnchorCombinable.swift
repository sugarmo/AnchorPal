//
//  AnchorCombinable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/5/25.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public protocol AnchorCombinable {}

public extension AnchorCombinable {
    func and<T>(_ other: T) -> AnchorPair<Self, T> where T: AnchorCombinable {
        AnchorPair(self, other)
    }
}

extension LayoutAnchor: AnchorCombinable {}
extension LayoutDimension: AnchorCombinable {}
extension Array: AnchorCombinable where Element: AnchorCombinable {}
extension AnchorPair: AnchorCombinable where F: AnchorCombinable, S: AnchorCombinable {}
