//
//  ConstraintBuilder.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/6.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

private let constraintsKey = AssociationKey<[Constraint]>(policy: .retain)
private let groupedConstraintsKey = AssociationKey<[AnyHashable: [Constraint]]>(policy: .retain)

private extension LayoutItem {
    func installedConstraints(group: AnyHashable?) -> [Constraint]? {
        if let group = group {
            return self[groupedConstraintsKey]?[group]
        } else {
            return self[constraintsKey]
        }
    }

    func setInstalledConstraints(_ constraints: [Constraint]?, forGroup group: AnyHashable?) {
        if let group = group {
            if let constraints = constraints {
                var dict = self[groupedConstraintsKey] ?? [:]
                dict[group] = constraints
                self[groupedConstraintsKey] = dict
            } else if var dict = self[groupedConstraintsKey] {
                dict[group] = nil
                if dict.isEmpty {
                    self[groupedConstraintsKey] = nil
                } else {
                    self[groupedConstraintsKey] = dict
                }
            }
        } else {
            self[constraintsKey] = constraints
        }
    }
}

public extension AnchorDSL where Object: LayoutItem {
    func constraints(group: AnyHashable? = nil) -> [Constraint] {
        object.installedConstraints(group: group) ?? []
    }
}

public class ConstraintBuilder {
    private static let currentBuilderKey = "AnchorPal.ConstraintBuilder"

    var statements: [ConstraintStatement] = []

    var isBuilding = false

    func startBuilding() {
        if !isBuilding {
            isBuilding = true
            statements.removeAll()
        }
    }

    func endBuilding() -> [ConstraintStatement] {
        if isBuilding {
            let newStatements = statements
            isBuilding = false
            statements.removeAll()
            return newStatements
        }
        return []
    }

    func add(_ statement: ConstraintStatement) {
        if isBuilding {
            statements.append(statement)
        }
    }

    func becomeCurrent() {
        Self.current = self
    }

    func resignCurrent() {
        if Self.current === self {
            Self.current = nil
        }
    }

    static var current: ConstraintBuilder? {
        get {
            Thread.current.threadDictionary[currentBuilderKey] as? ConstraintBuilder
        }
        set {
            Thread.current.threadDictionary[currentBuilderKey] = newValue
        }
    }

    static func makeConstraints<T>(item: T, closure: (AnchorDSL<T>) -> Void) -> [Constraint] where T: LayoutItem {
        let maker = ConstraintBuilder()
        maker.becomeCurrent()
        maker.startBuilding()
        closure(AnchorDSL(object: item))
        let statements = maker.endBuilding()
        maker.resignCurrent()
        return statements.map(\.constraint)
    }

    static func installConstraints<T>(item: T, group: AnyHashable?, closure: (AnchorDSL<T>) -> Void) -> [Constraint] where T: LayoutItem {
        let newConstraints = makeConstraints(item: item, closure: closure)
        newConstraints.activate()
        if var constraints = item.installedConstraints(group: group) {
            constraints.append(contentsOf: newConstraints)
            item.setInstalledConstraints(newConstraints, forGroup: group)
        } else {
            item.setInstalledConstraints(newConstraints, forGroup: group)
        }
        return newConstraints
    }

    static func uninstallConstraints(item: LayoutItem, group: AnyHashable?) {
        item.installedConstraints(group: group)?.deactivate()
        item.setInstalledConstraints(nil, forGroup: group)
    }

    static func reinstallConstraints<T>(item: T, group: AnyHashable?, closure: (AnchorDSL<T>) -> Void) -> [Constraint] where T: LayoutItem {
        uninstallConstraints(item: item, group: group)
        return installConstraints(item: item, group: group, closure: closure)
    }

    static func updateConstraintConstants(item: LayoutItem, group: AnyHashable?) {
        item.installedConstraints(group: group)?.updateConstants()
    }

    static func makeConstraints(closure: () -> Void) -> [Constraint] {
        let maker = ConstraintBuilder()
        maker.becomeCurrent()
        maker.startBuilding()
        closure()
        let statements = maker.endBuilding()
        maker.resignCurrent()
        return statements.map(\.constraint)
    }

    static func activateConstraints(closure: () -> Void) -> [Constraint] {
        let constraints = makeConstraints(closure: closure)
        constraints.activate()
        return constraints
    }
}

protocol ConstraintStatement {
    var constraint: Constraint { get }
}
