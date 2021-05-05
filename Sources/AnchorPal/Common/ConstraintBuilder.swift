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

private extension LayoutItem {
    var installedConstraints: [Constraint]? {
        get {
            self[constraintsKey]
        }
        set {
            self[constraintsKey] = newValue
        }
    }
}

public extension AnchorDSL where Object: LayoutItem {
    var constraints: [Constraint] {
        object.installedConstraints ?? []
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

    static func installConstraints<T>(item: T, closure: (AnchorDSL<T>) -> Void) -> [Constraint] where T: LayoutItem {
        let newConstraints = makeConstraints(item: item, closure: closure)
        newConstraints.activate()
        if var constraints = item.installedConstraints {
            constraints.append(contentsOf: newConstraints)
            item.installedConstraints = constraints
        } else {
            item.installedConstraints = newConstraints
        }
        return newConstraints
    }

    static func uninstallConstraints(item: LayoutItem) {
        item.installedConstraints?.deactivate()
        item.installedConstraints = nil
    }

    static func reinstallConstraints<T>(item: T, closure: (AnchorDSL<T>) -> Void) -> [Constraint] where T: LayoutItem {
        uninstallConstraints(item: item)
        return installConstraints(item: item, closure: closure)
    }

    static func updateConstraintConstants(item: LayoutItem) {
        item.installedConstraints?.updateConstants()
    }

    static func makeConstraintsWithoutItem(closure: () -> Void) -> [Constraint] {
        let maker = ConstraintBuilder()
        maker.becomeCurrent()
        maker.startBuilding()
        closure()
        let statements = maker.endBuilding()
        maker.resignCurrent()
        return statements.map(\.constraint)
    }

    static func installConstraintsWithoutItem(closure: () -> Void) -> [Constraint] {
        let constraints = makeConstraintsWithoutItem(closure: closure)
        constraints.activate()
        return constraints
    }
}

protocol ConstraintStatement {
    var constraint: Constraint { get }
}
