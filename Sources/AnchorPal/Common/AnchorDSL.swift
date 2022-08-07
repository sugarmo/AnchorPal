//
//  AnchorDSL.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/6.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public struct AnchorDSL<Object> {
    public var object: Object
}

public extension LayoutItem {
    var anc: AnchorDSL<Self> {
        AnchorDSL(object: self)
    }
}

public extension AnchorDSL where Object: LayoutItem {
    var constraints: [Constraint] {
        object.withConstraintGroup(id: nil) { group in
            group?.constraints ?? []
        }
    }

    func constraints(id: AnyHashable) -> [Constraint] {
        object.withConstraintGroup(id: id) { group in
            group?.constraints ?? []
        }
    }
}

public extension AnchorDSL where Object: LayoutItem {
    func makeConstraints(declaration: (_ the: Self) -> Void) -> [Constraint] {
        ConstraintBuilder.makeConstraints(item: object, declaration: declaration)
    }

    @discardableResult
    func installConstraints(declaration: (_ the: Self) -> Void) -> [Constraint] {
        ConstraintBuilder.installConstraints(item: object, id: nil, removeOld: false, storeOnly: false, condition: nil, declaration: declaration)
    }

    @discardableResult
    func reinstallConstraints(declaration: (_ the: Self) -> Void) -> [Constraint] {
        ConstraintBuilder.installConstraints(item: object, id: nil, removeOld: true, storeOnly: false, condition: nil, declaration: declaration)
    }

    func removeConstraints() {
        ConstraintBuilder.uninstallConstraints(item: object, id: nil)
    }

    func updateConstraintConstants() {
        ConstraintBuilder.updateConstraintConstants(item: object, id: nil)
    }
}

// MARK: Group Support

public extension AnchorDSL where Object: LayoutItem {
    @discardableResult
    func installConstraints(id: AnyHashable, declaration: (_ the: Self) -> Void) -> [Constraint] {
        ConstraintBuilder.installConstraints(item: object, id: id, removeOld: false, storeOnly: false, condition: nil, declaration: declaration)
    }

    @discardableResult
    func reinstallConstraints(id: AnyHashable, declaration: (_ the: Self) -> Void) -> [Constraint] {
        ConstraintBuilder.installConstraints(item: object, id: id, removeOld: true, storeOnly: false, condition: nil, declaration: declaration)
    }

    func removeConstraints(id: AnyHashable) {
        ConstraintBuilder.uninstallConstraints(item: object, id: id)
    }

    func updateConstraintConstants(id: AnyHashable) {
        ConstraintBuilder.updateConstraintConstants(item: object, id: id)
    }
}

// MARK: - Storage Support

public extension AnchorDSL where Object: LayoutItem {
    @discardableResult
    func storeConstraints(id: AnyHashable, declaration: (_ the: Self) -> Void) -> [Constraint] {
        ConstraintBuilder.installConstraints(item: object, id: id, removeOld: false, storeOnly: true, condition: nil, declaration: declaration)
    }

    func activateConstraints(id: AnyHashable) {
        ConstraintBuilder.setIsActiveConstraints(item: object, id: id, isActive: true)
    }

    func deactivateConstraints(id: AnyHashable) {
        ConstraintBuilder.setIsActiveConstraints(item: object, id: id, isActive: false)
    }
}

// MARK: Condition Support

public extension AnchorDSL where Object: LayoutItem {
    @discardableResult
    func installConstraints(declaration: (_ the: Self) -> Void, isActive condition: @escaping () -> Bool) -> [Constraint] {
        ConstraintBuilder.installConstraints(item: object, id: nil, removeOld: false, storeOnly: false, condition: condition, declaration: declaration)
    }

    @discardableResult
    func installConstraints(id: AnyHashable, declaration: (_ the: Self) -> Void, isActive condition: @escaping () -> Bool) -> [Constraint] {
        ConstraintBuilder.installConstraints(item: object, id: id, removeOld: false, storeOnly: false, condition: condition, declaration: declaration)
    }

    @discardableResult
    func reinstallConstraints(declaration: (_ the: Self) -> Void, isActive condition: @escaping () -> Bool) -> [Constraint] {
        ConstraintBuilder.installConstraints(item: object, id: nil, removeOld: true, storeOnly: false, condition: condition, declaration: declaration)
    }

    @discardableResult
    func reinstallConstraints(id: AnyHashable, declaration: (_ the: Self) -> Void, isActive condition: @escaping () -> Bool) -> [Constraint] {
        ConstraintBuilder.installConstraints(item: object, id: id, removeOld: true, storeOnly: false, condition: condition, declaration: declaration)
    }

    func updateConstraintConditions() {
        ConstraintBuilder.updateConstraintConditions(item: object, id: nil)
    }

    func updateConstraintConditions(id: AnyHashable) {
        ConstraintBuilder.updateConstraintConditions(item: object, id: id)
    }
}

public extension AnchorDSL where Object: LayoutItem & LayoutAnchorProvider {
    var topLeading: AnchorPair<XLayoutAnchor, YLayoutAnchor> { AnchorPair(leading, top) }
    var top: YLayoutAnchor { YLayoutAnchor(object.topAnchor, attribute: .top, subjectItem: object) }
    var topTrailing: AnchorPair<XLayoutAnchor, YLayoutAnchor> { AnchorPair(trailing, top) }

    var leading: XLayoutAnchor { XLayoutAnchor(object.leadingAnchor, attribute: .leading, subjectItem: object) }
    var center: AnchorPair<XLayoutAnchor, YLayoutAnchor> { AnchorPair(centerX, centerY) }
    var trailing: XLayoutAnchor { XLayoutAnchor(object.trailingAnchor, attribute: .trailing, subjectItem: object) }

    var bottomLeading: AnchorPair<XLayoutAnchor, YLayoutAnchor> { AnchorPair(leading, bottom) }
    var bottom: YLayoutAnchor { YLayoutAnchor(object.bottomAnchor, attribute: .bottom, subjectItem: object) }
    var bottomTrailing: AnchorPair<XLayoutAnchor, YLayoutAnchor> { AnchorPair(trailing, bottom) }

    var centerX: XLayoutAnchor { XLayoutAnchor(object.centerXAnchor, attribute: .centerX, subjectItem: object) }
    var centerY: YLayoutAnchor { YLayoutAnchor(object.centerYAnchor, attribute: .centerY, subjectItem: object) }

    var size: AnchorPair<LayoutDimension, LayoutDimension> { AnchorPair(width, height) }

    var width: LayoutDimension { LayoutDimension(object.widthAnchor, attribute: .width, subjectItem: object) }
    var height: LayoutDimension { LayoutDimension(object.heightAnchor, attribute: .height, subjectItem: object) }

    var xEdges: [XLayoutAnchor] { [leading, trailing] }
    var yEdges: [YLayoutAnchor] { [top, bottom] }
    var edges: AnchorPair<[XLayoutAnchor], [YLayoutAnchor]> { AnchorPair(xEdges, yEdges) }

    /// should not use since this anchor dose not support RTL layout.
    var _left: XLayoutAnchor { XLayoutAnchor(object.leftAnchor, attribute: .left, subjectItem: object) }
    /// should not use since this anchor dose not support RTL layout.
    var _right: XLayoutAnchor { XLayoutAnchor(object.rightAnchor, attribute: .right, subjectItem: object) }
    /// should not use since this anchor dose not support RTL layout.
    var _xEdges: [XLayoutAnchor] { [_left, _right] }
    /// should not use since this anchor dose not support RTL layout.
    var _edges: AnchorPair<[XLayoutAnchor], [YLayoutAnchor]> { AnchorPair(_xEdges, yEdges) }
}

public extension AnchorDSL where Object: LayoutItem & BaselineAnchorProvider {
    var firstBaseline: YLayoutAnchor { YLayoutAnchor(object.firstBaselineAnchor, attribute: .firstBaseline, subjectItem: object) }
    var lastBaseline: YLayoutAnchor { YLayoutAnchor(object.lastBaselineAnchor, attribute: .lastBaseline, subjectItem: object) }
}

public extension AnchorDSL where Object: LayoutView {
    var window: LayoutWindow {
        if let window = object.window {
            return window
        } else {
            fatalError("\(object) has no window at this time.")
        }
    }

    var superview: LayoutView {
        if let view = object.superview {
            return view
        } else {
            fatalError("\(object) has no superview at this time.")
        }
    }

    var margins: LayoutGuide {
        object.layoutMarginsGuide
    }

    var safeArea: LayoutGuide {
        object.safeAreaLayoutGuide
    }

    #if os(iOS) || os(tvOS)
        var readableMargins: LayoutGuide {
            object.readableContentGuide
        }
    #endif
}

public extension AnchorDSL where Object: LayoutGuide {
    var superview: LayoutView {
        if let view = object.superview {
            return view
        } else {
            fatalError("\(object) has no superview at this time.")
        }
    }
}

public enum Anc {
    public static func makeConstraints(declaration: () -> Void) -> [Constraint] {
        ConstraintBuilder.makeConstraints(declaration: declaration)
    }

    @discardableResult
    public static func activateConstraints(declaration: () -> Void) -> [Constraint] {
        ConstraintBuilder.activateConstraints(declaration: declaration)
    }
}

public extension LayoutView {
    func addSubview<Subview>(_ subview: Subview, installConstraints: (_ the: AnchorDSL<Subview>) -> Void) where Subview: LayoutView {
        addSubview(subview)
        subview.anc.installConstraints(declaration: installConstraints)
    }
}
