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

    weak var subjectItem: LayoutItem?

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

    init(subjectItem: LayoutItem, layoutConstraints: [NSLayoutConstraint], constant: ConstraintConstantValuable, priority: ConstraintPriorityValuable) {
        self.subjectItem = subjectItem
        self.layoutConstraints = layoutConstraints
        self.constant = constant
        self.priority = priority
    }

    public var isActive: Bool = false {
        didSet {
            if isActive {
                subjectItem?.ignoreAutoresizingMask()

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
