//
//  AnchorDSL.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/6.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public struct AnchorDSL<Object> {
    public var object: Object
}

public extension LayoutView {
    var anc: AnchorDSL<LayoutView> {
        AnchorDSL(object: self)
    }
}

public extension LayoutGuide {
    var anc: AnchorDSL<LayoutGuide> {
        AnchorDSL(object: self)
    }
}

public extension AnchorDSL where Object: GuideLayoutAnchorProvider {
    var leading: XLayoutAnchor { XLayoutAnchor(object.leadingAnchor, attribute: .leading, subjectItem: object) }
    var trailing: XLayoutAnchor { XLayoutAnchor(object.trailingAnchor, attribute: .trailing, subjectItem: object) }
    var top: YLayoutAnchor { YLayoutAnchor(object.topAnchor, attribute: .top, subjectItem: object) }
    var bottom: YLayoutAnchor { YLayoutAnchor(object.bottomAnchor, attribute: .bottom, subjectItem: object) }
    var width: LayoutDimension { LayoutDimension(object.widthAnchor, attribute: .width, subjectItem: object) }
    var height: LayoutDimension { LayoutDimension(object.heightAnchor, attribute: .height, subjectItem: object) }
    var centerX: XLayoutAnchor { XLayoutAnchor(object.centerXAnchor, attribute: .centerX, subjectItem: object) }
    var centerY: YLayoutAnchor { YLayoutAnchor(object.centerYAnchor, attribute: .centerY, subjectItem: object) }

    var center: AnchorPair<XLayoutAnchor, YLayoutAnchor> { AnchorPair(centerX, centerY) }
    var size: AnchorPair<LayoutDimension, LayoutDimension> { AnchorPair(width, height) }

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

    func makeConstraints(closure: (Self) -> Void) -> [Constraint] {
        ConstraintBuilder.makeConstraints(item: object, closure: closure)
    }

    @discardableResult
    func installConstraints(closure: (Self) -> Void) -> [Constraint] {
        ConstraintBuilder.installConstraints(item: object, closure: closure)
    }

    @discardableResult
    func reinstallConstraints(closure: (Self) -> Void) -> [Constraint] {
        ConstraintBuilder.reinstallConstraints(item: object, closure: closure)
    }

    func removeConstraints() {
        ConstraintBuilder.uninstallConstraints(item: object)
    }

    func updateConstraintConstants() {
        ConstraintBuilder.updateConstraintConstants(item: object)
    }
}

public extension AnchorDSL where Object: ViewLayoutAnchorProvider {
    var firstBaseline: YLayoutAnchor { YLayoutAnchor(object.firstBaselineAnchor, attribute: .firstBaseline, subjectItem: object) }
    var lastBaseline: YLayoutAnchor { YLayoutAnchor(object.lastBaselineAnchor, attribute: .lastBaseline, subjectItem: object) }
}

public extension AnchorDSL where Object: LayoutView {
    var window: LayoutView {
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

    @available(iOS 9, tvOS 9, macOS 11, *)
    var margins: LayoutGuide {
        object.layoutMarginsGuide
    }

    @available(iOS 11, tvOS 11, macOS 11, *)
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
    public static func makeConstraints(closure: () -> Void) -> [Constraint] {
        ConstraintBuilder.makeConstraints(closure: closure)
    }

    @discardableResult
    public static func activateConstraints(closure: () -> Void) -> [Constraint] {
        ConstraintBuilder.activateConstraints(closure: closure)
    }
}
