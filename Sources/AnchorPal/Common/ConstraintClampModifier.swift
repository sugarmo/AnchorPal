//
//  ConstraintClampModifier.swift
//
//
//  Created by Steven Mok on 2023/7/16.
//

import Foundation

public final class ConstraintClampModifier {
    public let minimumValue: ConstraintModifier<Void>
    public let maximumValue: ConstraintModifier<Void>

    init(minimumValue: ConstraintModifier<Void>, maximumValue: ConstraintModifier<Void>) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }

    @discardableResult
    public func minimumValuePriority(_ priority: ConstraintPriorityValuable) -> ConstraintClampModifier {
        minimumValue.priority(priority)
        return self
    }

    @discardableResult
    public func maximumValuePriority(_ priority: ConstraintPriorityValuable) -> ConstraintClampModifier {
        maximumValue.priority(priority)
        return self
    }
}
