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

protocol ConstraintStatement {
    var constraint: Constraint { get }
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

    enum InstallType {
        case normal
        case reinstall
        case storeOnly
    }

    static func installConstraints<T>(
        item: T,
        id: AnyHashable?,
        removeOld: Bool,
        storeOnly: Bool,
        condition: (() -> Bool)?,
        declaration: (AnchorDSL<T>) -> Void
    ) -> [Constraint] where T: LayoutItem {
        let newConstraints = makeConstraints(item: item, declaration: declaration)

        let run = ConstraintRun(constraints: newConstraints, condition: condition)

        if !storeOnly {
            run.validateConstraints()
        }

        item.withConstraintGroup(id: id) { group in
            if removeOld {
                group?.deactivate()
                group = nil
            }

            if group == nil {
                group = ConstraintGroup()
            }

            group?.addRun(run)
        }

        return newConstraints
    }

    static func uninstallConstraints(item: LayoutItem, id: AnyHashable?) {
        item.withConstraintGroup(id: id) { group in
            group?.deactivate()
            group = nil
        }
    }

    static func updateConstraintConstants(item: LayoutItem, id: AnyHashable?) {
        item.withConstraintGroup(id: id) { group in
            group?.updateConstants()
        }
    }

    static func setIsActiveConstraints<T>(item: T, id: AnyHashable?, isActive: Bool) where T: LayoutItem {
        item.withConstraintGroup(id: id) { group in
            if isActive {
                group?.activate()
            } else {
                group?.deactivate()
            }
        }
    }

    static func updateConstraintConditions(item: LayoutItem, id: AnyHashable?) {
        item.withConstraintGroup(id: id) { group in
            group?.updateConstraintConditions()
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
