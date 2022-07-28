//
//  Associable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2020/8/26.
//  Copyright © 2020 sugarmo. All rights reserved.
//

import ObjectiveC

enum AssociationPolicy {
    case retain
    case copy
    case assign
    case atomicRetain
    case atomicCopy

    var rawValue: objc_AssociationPolicy {
        switch self {
        case .retain:
            return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        case .copy:
            return .OBJC_ASSOCIATION_COPY_NONATOMIC
        case .assign:
            return .OBJC_ASSOCIATION_ASSIGN
        case .atomicRetain:
            return .OBJC_ASSOCIATION_RETAIN
        case .atomicCopy:
            return .OBJC_ASSOCIATION_COPY
        }
    }
}

final class AssociationKey<Value> {
    let policy: AssociationPolicy

    init(policy: AssociationPolicy) {
        self.policy = policy
    }
}

protocol Associable: AnyObject {
    func setAssociatedValue<Value>(_ value: Value?, for key: AssociationKey<Value>)
    func associatedValue<Value>(for key: AssociationKey<Value>) -> Value?
    func associatedValue<Value>(for key: AssociationKey<Value>, default defaultValue: () -> Value) -> Value
}

extension Associable {
    func setAssociatedValue<Value>(_ value: Value, for keyPath: ReferenceWritableKeyPath<Self, Value>, policy: AssociationPolicy) {
        let ptr = Pointer.bridge(obj: keyPath)
        objc_setAssociatedObject(self, ptr, value, policy.rawValue)
        self[keyPath: keyPath] = value
    }

    func setAssociatedValue<Value>(_ value: Value?, for key: AssociationKey<Value>) {
        let ptr = Pointer.bridge(obj: key)
        objc_setAssociatedObject(self, ptr, value, key.policy.rawValue)
    }

    func associatedValue<Value>(for key: AssociationKey<Value>) -> Value? {
        let ptr = Pointer.bridge(obj: key)
        return objc_getAssociatedObject(self, ptr) as? Value
    }

    func associatedValue<Value>(for key: AssociationKey<Value>, default defaultValue: @autoclosure () -> Value) -> Value {
        let ptr = Pointer.bridge(obj: key)

        if let result = objc_getAssociatedObject(self, ptr) as? Value {
            return result
        }

        let result = defaultValue()
        setAssociatedValue(result, for: key)
        return result
    }

    subscript<T>(key: AssociationKey<T>) -> T? {
        get {
            return associatedValue(for: key)
        }
        set {
            setAssociatedValue(newValue, for: key)
        }
    }

    // subscript has no argument label by default，unless you explicitly give one.
    subscript<T>(key: AssociationKey<T>, default defaultValue: @autoclosure () -> T) -> T {
        associatedValue(for: key, default: defaultValue)
    }
}

extension NSObject: Associable {}
