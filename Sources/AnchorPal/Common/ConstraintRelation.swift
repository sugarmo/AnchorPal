//
//  ConstraintRelation.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/6.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public enum ConstraintRelation: Int {
    case lessEqual = -1
    case equal = 0
    case greaterEqual = 1
}
