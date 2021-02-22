//
//  LayoutSuperviewGuide.swift
//  AnchorKit
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
    case margins
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
            return layoutMarginsGuide
        case .safeArea:
            return safeAreaLayoutGuide
        #if os(iOS) || os(tvOS)
            case .readableMargins:
                return readableContentGuide
        #endif
        }
    }
}
