//
//  Tests.swift
//  AnchorPalTests
//
//  Created by Steven Mok on 2021/2/11.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

@testable import AnchorPal
import XCTest

public typealias ConstraintAttribute = NSLayoutConstraint.Attribute

#if os(macOS)
    typealias TestView = NSView
    typealias TestWindow = NSWindow

    let TestPriorityRequired = NSLayoutConstraint.Priority.required
    let TestPriorityHigh = NSLayoutConstraint.Priority.defaultHigh
    let TestPriorityLow = NSLayoutConstraint.Priority.defaultLow
#else
    typealias TestView = UIView
    typealias TestWindow = UIWindow

    let TestPriorityRequired = UILayoutPriority.required
    let TestPriorityHigh = UILayoutPriority.defaultHigh
    let TestPriorityLow = UILayoutPriority.defaultLow

#endif

let cgEpsilon: CGFloat = 0.00001
let fEpsilon: Float = 0.00001
let dEpsilon: Double = 0.00001

class AnchorPalTests: XCTestCase {
    let view1 = TestView()
    let view2 = TestView()

    let window = TestWindow()

    override func setUp() {
        super.setUp()

        #if os(macOS)
            window.contentView!.addSubview(view1)
            window.contentView!.addSubview(view2)
        #else
            window.addSubview(view1)
            window.addSubview(view2)
        #endif
    }

    override func tearDown() {
        view1.removeFromSuperview()
        view2.removeFromSuperview()
    }
}

// MARK: - Overloaded operators

extension AnchorPalTests {
    func testBasicEquality() {
        let constraint = view1.anc.installConstraints { make in
            make.width.equalTo(view2.anc.width)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityRequired.rawValue, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testBasicLessThan() {
        let constraint = view1.anc.installConstraints { make in
            make.width.lessEqualTo(view2.anc.width)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityRequired.rawValue, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .lessThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testBasicGreaterThan() {
        let constraint = view1.anc.installConstraints { make in
            make.width.greaterEqualTo(view2.anc.width)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityRequired.rawValue, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .greaterThanOrEqual)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithOffset() {
        let constraint = view1.anc.installConstraints { make in
            make.width.equalTo(view2.anc.width).plus(10)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityRequired.rawValue, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithMultiplier() {
        let constraint = view1.anc.installConstraints { make in
            make.width.equalTo(view2.anc.width).multiply(0.5)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 0.5, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityRequired.rawValue, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithOffsetAndMultiplier() {
        let constraint = view1.anc.installConstraints { make in
            make.width.equalTo(view2.anc.width).plus(10).multiply(0.5)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 0.5, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityRequired.rawValue, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithPriorityConstant() {
        let constraint = view1.anc.installConstraints { make in
            make.width.equalTo(view2.anc.width).priority(.high)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityHigh.rawValue, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithPriorityLiteral() {
        let constraint = view1.anc.installConstraints { make in
            make.width.equalTo(view2.anc.width).priority(750)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityHigh.rawValue, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithPriorityConstantMath() {
        let constraint = view1.anc.installConstraints { make in
            make.width.equalTo(view2.anc.width).priority(.high - 1)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithPriorityLiteralMath() {
        let constraint = view1.anc.installConstraints { make in
            make.width.equalTo(view2.anc.width).priority(750 - 1)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithOffsetAndPriorityMath() {
        let constraint = view1.anc.installConstraints { make in
            make.width.equalTo(view2.anc.width).plus(10).priority(.high - 1)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testEqualityWithOffsetAndMultiplierAndPriorityMath() {
        let constraint = view1.anc.installConstraints { make in
            make.width.equalTo(view2.anc.width).plus(10).multiply(0.5).priority(.high - 1)
        }.firstLayoutConstraint!

        assertIdentical(constraint.firstItem, view1)
        assertIdentical(constraint.secondItem, view2)
        XCTAssertEqual(constraint.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.multiplier, 0.5, accuracy: cgEpsilon)
        XCTAssertEqual(constraint.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(constraint.isActive)
        XCTAssertEqual(constraint.relation, .equal)
        XCTAssertEqual(constraint.firstAttribute, .width)
        XCTAssertEqual(constraint.secondAttribute, .width)
    }

    func testCenterAnchors() {
        let constraints = view1.anc.installConstraints { make in
            make.center.equalTo(view2)
        }.layoutConstraints

        let horizontal = constraints[0]
        assertIdentical(horizontal.firstItem, view1)
        assertIdentical(horizontal.secondItem, view2)
        XCTAssertEqual(horizontal.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqual(horizontal.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(horizontal.priority.rawValue, TestPriorityRequired.rawValue, accuracy: fEpsilon)
        XCTAssertTrue(horizontal.isActive)
        XCTAssertEqual(horizontal.relation, .equal)
        XCTAssertEqual(horizontal.firstAttribute, .centerX)
        XCTAssertEqual(horizontal.secondAttribute, .centerX)

        let vertical = constraints[1]
        assertIdentical(vertical.firstItem, view1)
        assertIdentical(vertical.secondItem, view2)
        XCTAssertEqual(vertical.constant, 0, accuracy: cgEpsilon)
        XCTAssertEqual(vertical.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(vertical.priority.rawValue, TestPriorityRequired.rawValue, accuracy: fEpsilon)
        XCTAssertTrue(vertical.isActive)
        XCTAssertEqual(vertical.relation, .equal)
        XCTAssertEqual(vertical.firstAttribute, .centerY)
        XCTAssertEqual(vertical.secondAttribute, .centerY)
    }

    func testCenterAnchorsWithOffsetAndPriority() {
        let constraints = view1.anc.installConstraints { make in
            make.center.equalTo(view2).plus(10).priority(.high - 1)
        }.layoutConstraints

        let horizontal = constraints[0]
        assertIdentical(horizontal.firstItem, view1)
        assertIdentical(horizontal.secondItem, view2)
        XCTAssertEqual(horizontal.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(horizontal.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(horizontal.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(horizontal.isActive)
        XCTAssertEqual(horizontal.relation, .equal)
        XCTAssertEqual(horizontal.firstAttribute, .centerX)
        XCTAssertEqual(horizontal.secondAttribute, .centerX)

        let vertical = constraints[1]
        assertIdentical(vertical.firstItem, view1)
        assertIdentical(vertical.secondItem, view2)
        XCTAssertEqual(vertical.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(vertical.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(vertical.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(vertical.isActive)
        XCTAssertEqual(vertical.relation, .equal)
        XCTAssertEqual(vertical.firstAttribute, .centerY)
        XCTAssertEqual(vertical.secondAttribute, .centerY)
    }

    func testHorizontalAnchors() {
        let constraints = view1.anc.installConstraints { make in
            make.xEdges.insetFrom(view2).equalTo(10).priority(.high - 1)
        }.layoutConstraints

        let leading = constraints[0]
        assertIdentical(leading.firstItem, view1)
        assertIdentical(leading.secondItem, view2)
        XCTAssertEqual(leading.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(leading.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(leading.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(leading.isActive)
        XCTAssertEqual(leading.relation, .equal)
        XCTAssertEqual(leading.firstAttribute, .leading)
        XCTAssertEqual(leading.secondAttribute, .leading)

        let trailing = constraints[1]
        assertIdentical(trailing.firstItem, view2)
        assertIdentical(trailing.secondItem, view1)
        XCTAssertEqual(trailing.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(trailing.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(trailing.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(trailing.isActive)
        XCTAssertEqual(trailing.relation, .equal)
        XCTAssertEqual(trailing.firstAttribute, .trailing)
        XCTAssertEqual(trailing.secondAttribute, .trailing)
    }

    func testVerticalAnchors() {
        let constraints = view1.anc.installConstraints { make in
            make.yEdges.equalTo(view2).plus(10).priority(.high - 1)
        }.layoutConstraints

        let top = constraints[0]
        assertIdentical(top.firstItem, view1)
        assertIdentical(top.secondItem, view2)
        XCTAssertEqual(top.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(top.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(top.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(top.isActive)
        XCTAssertEqual(top.relation, .equal)
        XCTAssertEqual(top.firstAttribute, .top)
        XCTAssertEqual(top.secondAttribute, .top)

        let bottom = constraints[1]
        assertIdentical(bottom.firstItem, view1)
        assertIdentical(bottom.secondItem, view2)
        XCTAssertEqual(bottom.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(bottom.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(bottom.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(bottom.isActive)
        XCTAssertEqual(bottom.relation, .equal)
        XCTAssertEqual(bottom.firstAttribute, .bottom)
        XCTAssertEqual(bottom.secondAttribute, .bottom)
    }

    func testSizeAnchors() {
        let constraints = view1.anc.installConstraints { make in
            make.size.equalTo(view2).plus(10).priority(.high - 1)
        }.layoutConstraints

        let width = constraints[0]
        assertIdentical(width.firstItem, view1)
        assertIdentical(width.secondItem, view2)
        XCTAssertEqual(width.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(width.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(width.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(width.isActive)
        XCTAssertEqual(width.relation, .equal)
        XCTAssertEqual(width.firstAttribute, .width)
        XCTAssertEqual(width.secondAttribute, .width)

        let height = constraints[1]
        assertIdentical(height.firstItem, view1)
        assertIdentical(height.secondItem, view2)
        XCTAssertEqual(height.constant, 10, accuracy: cgEpsilon)
        XCTAssertEqual(height.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(height.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(height.isActive)
        XCTAssertEqual(height.relation, .equal)
        XCTAssertEqual(height.firstAttribute, .height)
        XCTAssertEqual(height.secondAttribute, .height)
    }

    func testSizeAnchorsWithConstants() {
        let constraints = view1.anc.installConstraints { make in
            make.size.equalTo(CGSize(width: 50, height: 100)).priority(.high - 1)
        }.layoutConstraints

        let width = constraints[0]
        assertIdentical(width.firstItem, view1)
        assertIdentical(width.secondItem, nil)
        XCTAssertEqual(width.constant, 50, accuracy: cgEpsilon)
        XCTAssertEqual(width.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(width.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(width.isActive)
        XCTAssertEqual(width.relation, .equal)
        XCTAssertEqual(width.firstAttribute, .width)
        XCTAssertEqual(width.secondAttribute, .notAnAttribute)

        let height = constraints[1]
        assertIdentical(height.firstItem, view1)
        assertIdentical(height.secondItem, nil)
        XCTAssertEqual(height.constant, 100, accuracy: cgEpsilon)
        XCTAssertEqual(height.multiplier, 1, accuracy: cgEpsilon)
        XCTAssertEqual(height.priority.rawValue, TestPriorityHigh.rawValue - 1, accuracy: fEpsilon)
        XCTAssertTrue(height.isActive)
        XCTAssertEqual(height.relation, .equal)
        XCTAssertEqual(height.firstAttribute, .height)
        XCTAssertEqual(height.secondAttribute, .notAnAttribute)
    }
}

// MARK: - Performance Tests

extension AnchorPalTests {
    private func runRepeatedEdgeConstraintAssignments(numTests: Int = 10000, assignment: () -> Constraint) {
        var constraint: Constraint?
        for _ in 0 ..< numTests {
            constraint?.deactivate()
            constraint = assignment()
        }
    }

    // MARK: Equal To

    func testPerformance_EqualTo() {
        measure {
            runRepeatedEdgeConstraintAssignments {
                let c = view1.anc.edges.equalTo(view2).constraint
                c.activate()
                return c
            }
        }
    }

    // MARK: Less Than or Equal To

    func testPerformance_LessThanOrEqualTo() {
        measure {
            runRepeatedEdgeConstraintAssignments {
                let c = view1.anc.edges.lessEqualTo(view2).constraint
                c.activate()
                return c
            }
        }
    }

    // MARK: Greater Than or Equal To

    func testPerformance_GreaterThanOrEqualTo() {
        measure {
            runRepeatedEdgeConstraintAssignments {
                let c = view1.anc.edges.greaterEqualTo(view2).constraint
                c.activate()
                return c
            }
        }
    }
}

// MARK: - Utility Functions and Extensions

extension AnchorPalTests {
    func assertIdentical(_ expression1: @autoclosure () -> AnyObject?, _ expression2: @autoclosure () -> AnyObject?, _ message: @autoclosure () -> String = "Objects were not identical", file: StaticString = #file, line: UInt = #line) {
        XCTAssertTrue(expression1() === expression2(), message(), file: file, line: line)
    }
}

// swiftlint:disable switch_case_alignment
extension ConstraintAttribute: CustomDebugStringConvertible {
    public var debugDescription: String {
        #if os(macOS)
            switch self {
            case .left: return "left"
            case .right: return "right"
            case .top: return "top"
            case .bottom: return "bottom"
            case .leading: return "leading"
            case .trailing: return "trailing"
            case .width: return "width"
            case .height: return "height"
            case .centerX: return "centerX"
            case .centerY: return "centerY"
            case .lastBaseline: return "lastBaseline"
            case .firstBaseline: return "firstBaseline"
            case .notAnAttribute: return "notAnAttribute"
            #if swift(>=5.0)
                @unknown default: return "unknown case \(self): \(rawValue)"
            #endif
            }
        #else
            switch self {
            case .left: return "left"
            case .right: return "right"
            case .top: return "top"
            case .bottom: return "bottom"
            case .leading: return "leading"
            case .trailing: return "trailing"
            case .width: return "width"
            case .height: return "height"
            case .centerX: return "centerX"
            case .centerY: return "centerY"
            case .lastBaseline: return "lastBaseline"
            case .firstBaseline: return "firstBaseline"
            case .leftMargin: return "leftMargin"
            case .rightMargin: return "rightMargin"
            case .topMargin: return "topMargin"
            case .bottomMargin: return "bottomMargin"
            case .leadingMargin: return "leadingMargin"
            case .trailingMargin: return "trailingMargin"
            case .centerXWithinMargins: return "centerXWithinMargins"
            case .centerYWithinMargins: return "centerYWithinMargins"
            case .notAnAttribute: return "notAnAttribute"
            #if swift(>=5.0)
                @unknown default: return "unknown case \(self): \(rawValue)"
            #endif
            }
        #endif
    }
}
// swiftlint:enable switch_case_alignment
