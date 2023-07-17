//
//  ConstraintRangeModifier.swift
//
//
//  Created by Steven Mok on 2023/7/16.
//

import Foundation

public final class ConstraintRangeModifier {
    public let minValue: ConstraintModifier<Void>
    public let maxValue: ConstraintModifier<Void>

    init(minValue: ConstraintModifier<Void>, maxValue: ConstraintModifier<Void>) {
        self.minValue = minValue
        self.maxValue = maxValue
    }

    @discardableResult
    public func minValuePriority(_ priority: ConstraintPriorityValuable) -> ConstraintRangeModifier {
        minValue.priority(priority)
        return self
    }

    @discardableResult
    public func maxValuePriority(_ priority: ConstraintPriorityValuable) -> ConstraintRangeModifier {
        maxValue.priority(priority)
        return self
    }
}
