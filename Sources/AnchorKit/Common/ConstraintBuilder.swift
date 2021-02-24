//
//  ConstraintBuilder.swift
//  AnchorKit
//
//  Created by Steven Mok on 2021/2/6.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

private let constraintsKey = AssociationKey<[Constraint]>(policy: .retain)

private extension Associable {
    var constraints: [Constraint]? {
        get {
            self[constraintsKey]
        }
        set {
            self[constraintsKey] = newValue
        }
    }
}

public class ConstraintBuilder {
    private static let currentBuilderKey = "AnchorKit.ConstraintBuilder"

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
        item.ignoreAutoresizingMask()
        closure(AnchorDSL(object: item))
        let statements = maker.endBuilding()
        maker.resignCurrent()
        return statements.map(\.constraint)
    }

    static func installConstraints<T>(item: T, closure: (AnchorDSL<T>) -> Void) -> [Constraint] where T: LayoutItem {
        let constraints = makeConstraints(item: item, closure: closure)
        constraints.activate()
        item.constraints = constraints
        return constraints
    }

    static func uninstallConstraints<T>(item: T) where T: LayoutItem {
        item.constraints?.deactivate()
        item.constraints = nil
    }

    static func reinstallConstraints<T>(item: T, closure: (AnchorDSL<T>) -> Void) -> [Constraint] where T: LayoutItem {
        uninstallConstraints(item: item)
        return installConstraints(item: item, closure: closure)
    }

    static func updateConstraintConstants<T>(item: T) where T: LayoutItem {
        item.constraints?.updateConstants()
    }
}

protocol ConstraintStatement {
    var constraint: Constraint { get }
}
