//
//  ConstraintRun.swift
//
//
//  Created by Steven Mok on 2022/8/6.
//

import Foundation

final class ConstraintRun {
    init(constraints: [Constraint], condition: (() -> Bool)? = nil) {
        self.constraints = constraints
        self.condition = condition
    }

    var isEstablished: Bool {
        condition?() ?? true
    }

    let constraints: [Constraint]

    let condition: (() -> Bool)?

    func validateConstraints() {
        if isEstablished {
            constraints.activate()
        } else {
            constraints.deactivate()
        }
    }

    var activeConstraints: [Constraint] {
        constraints.filter { $0.isActive }
    }

    var inactiveConstraints: [Constraint] {
        constraints.filter { !$0.isActive }
    }
}
