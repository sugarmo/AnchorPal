//
//  ConstraintRelation.swift
//  AnchorKit
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

//    static func * (lhs: ConstraintRelation, rhs: AnchorEdge) -> ConstraintRelation {
//        let rawValue = lhs.rawValue * rhs.rawValue
//        if rawValue > 0 {
//            return .greaterEqual
//        } else if rawValue < 0 {
//            return .lessEqual
//        } else {
//            return .equal
//        }
//    }
}

