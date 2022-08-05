//
//  ConstraintBuilder.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/6.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

private let constraintsKey = AssociationKey<[Constraint]>(policy: .retain)
private let groupedConstraintsKey = AssociationKey<[AnyHashable: [Constraint]]>(policy: .retain)

private extension LayoutItem {
    func storedConstraints(group: AnyHashable?) -> [Constraint]? {
        if let group = group {
            return self[groupedConstraintsKey]?[group]
        } else {
            return self[constraintsKey]
        }
    }

    func storeConstraints(_ constraints: [Constraint]?, forGroup group: AnyHashable?) {
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
        object.storedConstraints(group: group) ?? []
    }
}

final class ConstraintBuilder {
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

    static func makeConstraints<T>(item: T, declaration: (AnchorDSL<T>) -> Void) -> [Constraint] where T: LayoutItem {
        let maker = ConstraintBuilder()
        maker.becomeCurrent()
        maker.startBuilding()
        declaration(AnchorDSL(object: item))
        let statements = maker.endBuilding()
        maker.resignCurrent()
        return statements.map(\.constraint)
    }

    static func installConstraints<T>(item: T, group: AnyHashable?, declaration: (AnchorDSL<T>) -> Void) -> [Constraint] where T: LayoutItem {
        let newConstraints = makeConstraints(item: item, declaration: declaration)
        newConstraints.activate()
        if var constraints = item.storedConstraints(group: group) {
            constraints.append(contentsOf: newConstraints)
            item.storeConstraints(newConstraints, forGroup: group)
        } else {
            item.storeConstraints(newConstraints, forGroup: group)
        }
        return newConstraints
    }

    static func uninstallConstraints(item: LayoutItem, group: AnyHashable?) {
        item.storedConstraints(group: group)?.deactivate()
        item.storeConstraints(nil, forGroup: group)
    }

    static func reinstallConstraints<T>(item: T, group: AnyHashable?, declaration: (AnchorDSL<T>) -> Void) -> [Constraint] where T: LayoutItem {
        uninstallConstraints(item: item, group: group)
        return installConstraints(item: item, group: group, declaration: declaration)
    }

    static func updateConstraintConstants(item: LayoutItem, group: AnyHashable?) {
        item.storedConstraints(group: group)?.updateConstants()
    }

    static func storeConstraints<T>(item: T, group: AnyHashable?, declaration: (AnchorDSL<T>) -> Void) -> [Constraint] where T: LayoutItem {
        let newConstraints = makeConstraints(item: item, declaration: declaration)
        if var constraints = item.storedConstraints(group: group) {
            constraints.append(contentsOf: newConstraints)
            item.storeConstraints(newConstraints, forGroup: group)
        } else {
            item.storeConstraints(newConstraints, forGroup: group)
        }
        return newConstraints
    }

    static func setIsActiveConstraints<T>(item: T, group: AnyHashable?, isActive: Bool) where T: LayoutItem {
        if let constraints = item.storedConstraints(group: group) {
            if isActive {
                constraints.activate()
            } else {
                constraints.deactivate()
            }
        }
    }
    }

    static func makeConstraints(declaration: () -> Void) -> [Constraint] {
        let maker = ConstraintBuilder()
        maker.becomeCurrent()
        maker.startBuilding()
        declaration()
        let statements = maker.endBuilding()
        maker.resignCurrent()
        return statements.map(\.constraint)
    }

    static func activateConstraints(declaration: () -> Void) -> [Constraint] {
        let constraints = makeConstraints(declaration: declaration)
        constraints.activate()
        return constraints
    }
}

protocol ConstraintStatement {
    var constraint: Constraint { get }
}
