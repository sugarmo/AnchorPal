//
//  AnchorDSL.swift
//  AnchorKit
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
    var leading: XLayoutAnchor { XLayoutAnchor(object.leadingAnchor, attribute: .leading, owningItem: object) }
    var trailing: XLayoutAnchor { XLayoutAnchor(object.trailingAnchor, attribute: .trailing, owningItem: object) }
    var left: XLayoutAnchor { XLayoutAnchor(object.leftAnchor, attribute: .left, owningItem: object) }
    var right: XLayoutAnchor { XLayoutAnchor(object.rightAnchor, attribute: .right, owningItem: object) }
    var top: YLayoutAnchor { YLayoutAnchor(object.topAnchor, attribute: .top, owningItem: object) }
    var bottom: YLayoutAnchor { YLayoutAnchor(object.bottomAnchor, attribute: .bottom, owningItem: object) }
    var width: LayoutDimension { LayoutDimension(object.widthAnchor, attribute: .width, owningItem: object) }
    var height: LayoutDimension { LayoutDimension(object.heightAnchor, attribute: .height, owningItem: object) }
    var centerX: XLayoutAnchor { XLayoutAnchor(object.centerXAnchor, attribute: .centerX, owningItem: object) }
    var centerY: YLayoutAnchor { YLayoutAnchor(object.centerYAnchor, attribute: .centerY, owningItem: object) }

    var center: AnchorPair<XLayoutAnchor, YLayoutAnchor> { AnchorPair(centerX, centerY) }
    var size: AnchorPair<LayoutDimension, LayoutDimension> { AnchorPair(width, height) }

    var edges: AnchorPair<[XLayoutAnchor], [YLayoutAnchor]> { AnchorPair([left, right], [top, bottom]) }

    var xEdges: [XLayoutAnchor] { [left, right] }
    var yEdges: [YLayoutAnchor] { [top, bottom] }

    var directionalXEdges: [XLayoutAnchor] { [leading, trailing] }
    var directionalEdges: AnchorPair<[XLayoutAnchor], [YLayoutAnchor]> { AnchorPair([leading, trailing], [top, bottom]) }

    func makeConstraints(closure: (Self) -> Void) -> [Constraint] {
        ConstraintBuilder.makeConstraints(item: object, closure: closure)
    }

    func installConstraints(closure: (Self) -> Void) {
        ConstraintBuilder.installConstraints(item: object, closure: closure)
    }

    func reinstallConstraints(closure: (Self) -> Void) {
        ConstraintBuilder.reinstallConstraints(item: object, closure: closure)
    }

    func removeConstraints() {
        ConstraintBuilder.uninstallConstraints(item: object)
    }

    func updateConstraintConstants() {
        ConstraintBuilder.updateConstraintConstants(item: object)
    }
}

extension AnchorDSL where Object: ViewLayoutAnchorProvider {
    var firstBaseline: YLayoutAnchor { YLayoutAnchor(object.firstBaselineAnchor, attribute: .firstBaseline, owningItem: object) }
    var lastBaseline: YLayoutAnchor { YLayoutAnchor(object.lastBaselineAnchor, attribute: .lastBaseline, owningItem: object) }
}
