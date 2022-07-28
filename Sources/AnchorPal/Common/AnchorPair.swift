//
//  AnchorPair.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/10.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public struct AnchorPair<F, S> {
    var first: F
    var second: S

    init(_ first: F, _ second: S) {
        self.first = first
        self.second = second
    }
}
