//
//  ConstraintRelation.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/6.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public enum ConstraintRelation: Int {
    case lessEqual = -1
    case equal = 0
    case greaterEqual = 1
}
