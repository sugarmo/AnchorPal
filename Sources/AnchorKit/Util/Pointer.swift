//
//  Pointer.swift
//  Picsew
//
//  Created by Steven Mok on 2018/9/18.
//  Copyright © 2018年 sugarmo. All rights reserved.
//

import Foundation

enum Pointer {
    static func bridge<T: AnyObject>(obj: T) -> UnsafeRawPointer {
        return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
    }

    static func bridge<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
        return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
    }

    static func bridgeRetained<T: AnyObject>(obj: T) -> UnsafeRawPointer {
        return UnsafeRawPointer(Unmanaged.passRetained(obj).toOpaque())
    }

    static func bridgeTransfer<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
        return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
    }
}
