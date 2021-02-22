//
//  ConstraintDescription.swift
//  AnchorKit
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
    var layoutConstraints: [NSLayoutConstraint]

    var constant: ConstraintConstantValuable {
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

    var priority: ConstraintPriorityValuable {
        didSet {
            layoutConstraints.forEach {
                $0.priority = priority.constraintPriorityValue
            }
        }
    }

    init(layoutConstraints: [NSLayoutConstraint], constant: ConstraintConstantValuable, priority: ConstraintPriorityValuable) {
        self.layoutConstraints = layoutConstraints
        self.constant = constant
        self.priority = priority
    }

    public func activate() {
        NSLayoutConstraint.activate(layoutConstraints)
    }

    public func deactivate() {
        NSLayoutConstraint.deactivate(layoutConstraints)
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
}
