//
//  LayoutSuperviewGuide.swift
//  AnchorPal
//
//  Created by Steven Mok on 2021/2/14.
//

#if os(iOS) || os(tvOS)
    import UIKit
#else
    import AppKit
#endif

public enum LayoutSuperviewGuide {
    case edges
    @available(iOS 9, tvOS 9, macOS 11, *)
    case margins
    @available(iOS 11, tvOS 11, macOS 11, *)
    case safeArea
    #if os(iOS) || os(tvOS)
        case readableMargins
    #endif
}

extension LayoutView {
    func layoutItem(for guide: LayoutSuperviewGuide) -> LayoutItem {
        switch guide {
        case .edges:
            return self
        case .margins:
            if #available(iOS 9, tvOS 9, macOS 11, *) {
                return layoutMarginsGuide
            } else {
                return self
            }
        case .safeArea:
            if #available(iOS 11, tvOS 11, macOS 11, *) {
                return safeAreaLayoutGuide
            } else {
                if #available(iOS 9, tvOS 9, macOS 11.0, *) {
                    return layoutMarginsGuide
                } else {
                    return self
                }
            }
        #if os(iOS) || os(tvOS)
            case .readableMargins:
                return readableContentGuide
        #endif
        }
    }
}
