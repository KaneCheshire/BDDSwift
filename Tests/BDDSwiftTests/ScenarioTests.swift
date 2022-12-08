import XCTest
@testable import BDDSwift

final class BDDSwiftTests: XCTestCase {

    func test_stepsPerformedInOrder_passingFunctionsAsArgs() {
        let given = expectation(description: "given")
        let andAfterGiven = expectation(description: "and after given")
        let andAfterAndAfterGiven = expectation(description: "and after and after given")
        let when = expectation(description: "when")
        let andAfterWhen = expectation(description: "and after when")
        let andAfterAndAfterWhen = expectation(description: "and after and after when")
        let then = expectation(description: "then")
        let andAfterThen = expectation(description: "and after then")
        let andAfterAndAfterThen = expectation(description: "and after and after then")
        Scenario("do something") {
            Given(given.fulfill)
            And(andAfterGiven.fulfill)
            And(andAfterAndAfterGiven.fulfill)
            When(when.fulfill)
            And(andAfterWhen.fulfill)
            And(andAfterAndAfterWhen.fulfill)
            Then(then.fulfill)
            And(andAfterThen.fulfill)
            And(andAfterAndAfterThen.fulfill)
        }
        wait(for: [
            given,
            andAfterGiven,
            andAfterAndAfterGiven,
            when,
            andAfterWhen,
            andAfterAndAfterWhen,
            then,
            andAfterThen,
            andAfterAndAfterThen,
        ], timeout: 0, enforceOrder: true)
    }

    func test_stepsPerformedInOrder_autoclosures() {
        let given = expectation(description: "given")
        let andAfterGiven = expectation(description: "and after given")
        let andAfterAndAfterGiven = expectation(description: "and after and after given")
        let when = expectation(description: "when")
        let andAfterWhen = expectation(description: "and after when")
        let andAfterAndAfterWhen = expectation(description: "and after and after when")
        let then = expectation(description: "then")
        let andAfterThen = expectation(description: "and after then")
        let andAfterAndAfterThen = expectation(description: "and after and after then")
        Scenario("do something") {
            Given(given.fulfill())
            And(andAfterGiven.fulfill())
            And(andAfterAndAfterGiven.fulfill())
            When(when.fulfill())
            And(andAfterWhen.fulfill())
            And(andAfterAndAfterWhen.fulfill())
            Then(then.fulfill())
            And(andAfterThen.fulfill())
            And(andAfterAndAfterThen.fulfill())
        }
        wait(for: [
            given,
            andAfterGiven,
            andAfterAndAfterGiven,
            when,
            andAfterWhen,
            andAfterAndAfterWhen,
            then,
            andAfterThen,
            andAfterAndAfterThen,
        ], timeout: 0, enforceOrder: true)
    }

    func test_lastScenarioStored() {
        XCTAssertNil(Scenario.lastExecutedScenario)
        let givenA = expectation(description: "given a")
        Scenario("a") {
            Given {
                XCTAssertEqual(Scenario.lastExecutedScenario?.description, "a")
                givenA.fulfill()
            }
            When {}
            Then {}
        }
        let givenB = expectation(description: "given b")
        Scenario("b") {
            Given {
                XCTAssertEqual(Scenario.lastExecutedScenario?.description, "b")
                givenB.fulfill()
            }
            When {}
            Then {}
        }
        wait(for: [
            givenA,
            givenB,
        ], timeout: 0, enforceOrder: true)
    }

    func test_stepsChainConvertedToArrayInCorrectOrder() {
        var scenario = Scenario("") {
            Given {}
            And {}
            When {}
            And {}
            Then {}
            And {}
        }
        let lazilyLoadedSteps = scenario.steps
        XCTAssertEqual(lazilyLoadedSteps.count, 6)
        XCTAssertEqual(lazilyLoadedSteps[0].description, "Given")
        XCTAssertEqual(lazilyLoadedSteps[1].description, "And (after Given)")
        XCTAssertEqual(lazilyLoadedSteps[2].description, "When")
        XCTAssertEqual(lazilyLoadedSteps[3].description, "And (after When)")
        XCTAssertEqual(lazilyLoadedSteps[4].description, "Then")
        XCTAssertEqual(lazilyLoadedSteps[5].description, "And (after Then)")
    }
}
