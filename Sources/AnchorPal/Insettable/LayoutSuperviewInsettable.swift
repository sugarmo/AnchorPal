//
//  LayoutSuperviewInsettable.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/14.
//

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public protocol LayoutSuperviewInsettable: ConstraintSubjectable, LayoutItemInsettable {
    func insetFromSuperview<T>(_ keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> InsetResult
}

public extension LayoutSuperviewInsettable {
    func insetFromSuperview() -> InsetResult {
        return insetFromSuperview(\.object)
    }
}

public extension LayoutSuperviewInsettable where InsetResult: ConstraintConstantRelatable {
    @discardableResult
    func padding(_ padding: ConstraintConstantValuable) -> ConstraintModifier<ConstraintConstantTarget> {
        return insetFromSuperview().equalTo(padding)
    }

    @discardableResult
    func padding<T>(_ padding: ConstraintConstantValuable, from keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> ConstraintModifier<ConstraintConstantTarget> {
        return insetFromSuperview(keyPath).equalTo(padding)
    }
}

extension LayoutAnchor: LayoutSuperviewInsettable {
    public func insetFromSuperview<T>(_ keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> InsetResult {
        guard let superview = subjectItem.superview else {
            fatalError("\(subjectItem) has no superview at this time.")
        }

        let object = superview.anc[keyPath: keyPath]

        switch object {
        case let item as LayoutItem:
            return insetFrom(item)
        default:
            fatalError("Not supported target.")
        }
    }
}

extension Array: LayoutSuperviewInsettable where Element: LayoutSuperviewInsettable {
    public func insetFromSuperview<T>(_ keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> [Element.InsetResult] {
        map { $0.insetFromSuperview(keyPath) }
    }
}

extension AnchorPair: LayoutSuperviewInsettable where F: LayoutSuperviewInsettable, S: LayoutSuperviewInsettable {
    public func insetFromSuperview<T>(_ keyPath: KeyPath<AnchorDSL<LayoutView>, T>) -> AnchorPair<F.InsetResult, S.InsetResult> {
        let first = self.first.insetFromSuperview(keyPath)
        let second = self.second.insetFromSuperview(keyPath)
        return AnchorPair<F.InsetResult, S.InsetResult>(first, second)
    }
}
