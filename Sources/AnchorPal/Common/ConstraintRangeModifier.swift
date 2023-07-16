//
//  ConstraintRangeModifier.swift
//
//
//  Created by Steven Mok on 2023/7/16.
//

import Foundation

public final class ConstraintRangeModifier {
    public let lowerBound: ConstraintModifier<Void>
    public let upperBound: ConstraintModifier<Void>

    init(lowerBound: ConstraintModifier<Void>, upperBound: ConstraintModifier<Void>) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }

    @discardableResult
    public func lowerBoundPriority(_ priority: ConstraintPriorityValuable) -> ConstraintRangeModifier {
        lowerBound.priority(priority)
        return self
    }

    @discardableResult
    public func upperBoundPriority(_ priority: ConstraintPriorityValuable) -> ConstraintRangeModifier {
        upperBound.priority(priority)
        return self
    }
}
