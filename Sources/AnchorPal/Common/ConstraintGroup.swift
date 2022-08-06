//
//  ConstraintGroup.swift
//
//
//  Created by Steven Mok on 2022/8/6.
//

import Foundation

final class ConstraintGroup {
    private(set) var runs: [ConstraintRun] = []

    var constraints: [Constraint] {
        runs.flatMap { run in
            run.constraints
        }
    }

    var establishedConstraints: [Constraint] {
        runs.flatMap { run -> [Constraint] in
            if run.isEstablished {
                return run.constraints
            } else {
                return []
            }
        }
    }

    var unestablishedConstraints: [Constraint] {
        runs.flatMap { run -> [Constraint] in
            if !run.isEstablished {
                return run.constraints
            } else {
                return []
            }
        }
    }

    var activeConstraints: [Constraint] {
        runs.flatMap { run in
            run.activeConstraints
        }
    }

    var inactiveConstraints: [Constraint] {
        runs.flatMap { run in
            run.inactiveConstraints
        }
    }

    func addRun(_ run: ConstraintRun) {
        runs.append(run)
    }

    func addRun(constraints: [Constraint], condition: (() -> Bool)? = nil) {
        let run = ConstraintRun(constraints: constraints, condition: condition)
        runs.append(run)
    }

    func updateConstraintConditions() {
        // must deactivate first to avoid simultaneously satisfy warning.
        unestablishedConstraints.deactivate()
        establishedConstraints.activate()
    }

    func activate() {
        constraints.activate()
    }

    func deactivate() {
        constraints.deactivate()
    }

    func updateConstants() {
        constraints.updateConstants()
    }
}

private let groupsByIDsKey = AssociationKey<[AnyHashable: ConstraintGroup]>(policy: .retain)

extension LayoutItem {
    func withConstraintGroupsByIDs<T>(handler: (inout [AnyHashable: ConstraintGroup]?) throws -> T) rethrows -> T {
        var groupsByIDs = self[groupsByIDsKey]

        let r = try handler(&groupsByIDs)

        if groupsByIDs == nil || groupsByIDs!.isEmpty {
            self[groupsByIDsKey] = nil
        } else {
            self[groupsByIDsKey] = groupsByIDs
        }

        return r
    }

    func withConstraintGroup<T>(id: AnyHashable?, handler: (inout ConstraintGroup?) throws -> T) rethrows -> T {
        try withConstraintGroupsByIDs { groupsByIDs in
            let key = id ?? AnyHashable(ObjectIdentifier(self))

            var group = groupsByIDs?[key]

            let r = try handler(&group)

            if group == nil {
                groupsByIDs?[key] = nil
            } else {
                if groupsByIDs == nil {
                    groupsByIDs = [:]
                }

                groupsByIDs?[key] = group
            }

            return r
        }
    }
}
