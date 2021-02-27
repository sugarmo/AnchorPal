//
//  ConstraintDescription.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/2.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

extension NSLayoutConstraint {
    private static let positionKey = AssociationKey<AnchorPosition>(policy: .retain)

    var position: AnchorPosition? {
        get {
            self[Self.positionKey]
        }
        set {
            self[Self.positionKey] = newValue
        }
    }

    func position(_ newValue: AnchorPosition) -> NSLayoutConstraint {
        position = newValue
        return self
    }
}

public class Constraint {
    public var layoutConstraints: [NSLayoutConstraint]

    var subjectViews: Set<Weak<LayoutView>>

    public subscript(index: Int) -> NSLayoutConstraint {
        layoutConstraints[index]
    }

    public var firstLayoutConstraint: NSLayoutConstraint? {
        layoutConstraints.first
    }

    public var constant: ConstraintConstantValuable {
        didSet {
            updateConstant()
        }
    }

    public func updateConstant() {
        layoutConstraints.forEach {
            if let attr = $0.position {
                $0.constant = constant.constraintConstantValue(for: attr)
            }
        }
    }

    public var priority: ConstraintPriorityValuable {
        didSet {
            layoutConstraints.forEach {
                $0.priority = priority.constraintPriorityValue
            }
        }
    }

    private static func makeSet(_ items: [LayoutItem]) -> Set<Weak<LayoutView>> {
        Set(items.compactMap {
            $0 as? LayoutView
        }.map {
            Weak(object: $0)
        })
    }

    init(subjectItems: [LayoutItem], layoutConstraints: [NSLayoutConstraint], constant: ConstraintConstantValuable, priority: ConstraintPriorityValuable) {
        subjectViews = Self.makeSet(subjectItems)
        self.layoutConstraints = layoutConstraints
        self.constant = constant
        self.priority = priority
    }

    public var isActive: Bool = false {
        didSet {
            if isActive {
                subjectViews.forEach {
                    $0.object?.translatesAutoresizingMaskIntoConstraints = false
                }

                NSLayoutConstraint.activate(layoutConstraints)
            } else {
                NSLayoutConstraint.deactivate(layoutConstraints)
            }
        }
    }

    public func activate() {
        isActive = true
    }

    public func deactivate() {
        isActive = false
    }
}

extension Array where Element: Constraint {
    public func updateConstants() {
        forEach {
            $0.updateConstant()
        }
    }

    public func activate() {
        NSLayoutConstraint.activate(flatMap(\.layoutConstraints))
    }

    public func deactivate() {
        NSLayoutConstraint.deactivate(flatMap(\.layoutConstraints))
    }

    public var layoutConstraints: [NSLayoutConstraint] {
        flatMap(\.layoutConstraints)
    }

    public var firstLayoutConstraint: NSLayoutConstraint? {
        first?.firstLayoutConstraint
    }
}

// Util

final class Weak<T: AnyObject & Hashable>: Hashable {
    weak var object: T?

    init(object: T) {
        self.object = object
    }

    static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        lhs.object == rhs.object
    }

    func hash(into hasher: inout Hasher) {
        object?.hash(into: &hasher)
    }
}
