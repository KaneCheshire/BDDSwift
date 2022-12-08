import Foundation
import XCTest

/// A Scenario describes a set of steps that should happen to result in some state.
/// You create a scenario with a description that briefly describes what happens in the
/// scenario, like "Logging in shows home screen", and then use the steps builder
/// to actually provide the specific steps required.
/// The steps builder _requires_ that you include a Given, When and Then
/// step, in that order, and only one of each.
///
/// The compiler will not allow more then one Given, When or Then step per scenario,
/// but it will allow And steps between them and after Then.
///
/// You can access the last executed scenario using the static variable:
/// ```swift
/// Scenario.lastExecutedScenario
/// ```
///
/// And you can additionally access the last executed step in the scenario:
/// ```swift
/// Scenario.lastExecutedScenario?.lastExecutedStep
/// ```
///
/// The scenario will hold the description, and the step will hold useful information like
/// the file and line number where the step was created.
///
/// This information is particularly useful when interrogating failures or hooking into
/// test failures to provide custom reports for CI etc.
public struct Scenario {

    /// The most recently executed scenario.
    static public private(set) var lastExecutedScenario: Scenario?

    /// The most recently executed step for this scenario.
    public fileprivate(set) var lastExecutedStep: Step?
    /// The description of this scenario.
    public let description: String
    /// A lazily-loaded array of the steps. They are lazily loaded when first accessed
    /// since BDDSwift uses a linked-list to chain the steps and keep the order.
    public private(set) lazy var steps: [Step] = stepsChain.toArray

    private var stepsChain: Step

    @discardableResult
    public init(
        _ description: String,
        @StepsBuilder stepsBuilder steps: () -> Step
    ) {
        self.description = description
        self.stepsChain = steps()
        Self.lastExecutedScenario = self
        let totalStepCount = stepsChain.index + 1
        let activityName = "Running scenario with \(totalStepCount) steps: \(description)"
        XCTContext.runActivity(named: activityName) { _ in
            stepsChain.performInSequence(in: &self, totalStepCount: totalStepCount)
        }
    }
}

private extension Step {

    func performInSequence(in scenario: inout Scenario, totalStepCount: Int) {
        if let previous { previous.performInSequence(in: &scenario, totalStepCount: totalStepCount) }
        let activityName = "Performing step \(index + 1) of \(totalStepCount): \(description)"
        XCTContext.runActivity(named: activityName) { _ in
            scenario.lastExecutedStep = self
            logic()
        }
    }
}

public extension Step {

    /// Converts a chain of steps into an array.
    var toArray: [Step] {
        var array: [Step] = []
        toArray(with: &array)
        return array
    }

    private func toArray(with array: inout [Step]) {
        if let previous {
            previous.toArray(with: &array)
        }
        array.append(self)
    }
}
