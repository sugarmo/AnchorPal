//
//  Pointer.swift
//  AnchorPal
//
//  Created by Steven Mok on 2018/9/18.
//  Copyright © 2018年 sugarmo. All rights reserved.
//

import Foundation

func toPointer<T: AnyObject>(_ obj: T) -> UnsafeRawPointer {
    return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

func toObject<T: AnyObject>(_ ptr: UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}
