import Foundation

/// Represents a step in a scenario.
public protocol Step {

    var logic: () -> Void { get }
    var previous: Step? { get set }
    var index: Int { get set }
    var description: String { get set }
    var file: StaticString { get }
    var line: UInt { get }
}

/// Represents the Given step in a BDD scenario.
///
/// You must provide one Given step at the start of a Scenario.
///
/// When using a steps builder, the compiler will enforce that a single Given
/// step is defined and that it is the first step in the scenario.
public struct Given: ValidInitialStep {

    public let logic: () -> Void
    public var previous: Step?
    public var index: Int = 0
    public var description: String = ""
    public let file: StaticString
    public let line: UInt

    public init(
        _ logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        _ logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        I logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        I logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        the logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        the logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }
}

/// Represents the When step in a BDD scenario.
///
/// You must provide one When step in a Scenario, and it must be
/// after the Given step and before the Then step.
///
/// When using a steps builder, the compiler will enforce that there is only one When
/// step and that it is positioned between Given and Then.
public struct When: ValidInitialStep, ValidAfterGiven_BeforeThen {

    public let logic: () -> Void
    public var previous: Step?
    public var index: Int = 0
    public var description: String = ""
    public let file: StaticString
    public let line: UInt

    public init(
        _ logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        _ logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        I logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        I logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        the logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        the logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }
}

/// Represents the Then step in a BDD scenario.
///
/// You must provide one Then step in a Scenario, and it must be
/// after the When step.
///
/// When using a steps builder, the compiler will enforce that there is only one Then
/// step and that it is positioned between after When.
public struct Then: ValidAfterWhen {

    public let logic: () -> Void
    public var previous: Step?
    public var index: Int = 0
    public var description: String = ""
    public let file: StaticString
    public let line: UInt

    public init(
        _ logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        _ logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        I logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        I logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        the logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        the logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }
}

public struct And: ValidAfterGiven_BeforeWhen, ValidAfterWhen_BeforeThen, ValidAfterThen {

    public let logic: () -> Void
    public var previous: Step?
    public var index: Int = 0
    public var description: String = ""
    public let file: StaticString
    public let line: UInt

    public init(
        _ logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        _ logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        I logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        I logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        the logic: @escaping () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }

    public init(
        the logic: @escaping @autoclosure () -> Void,
        _ file: StaticString = #file,
        _ line: UInt = #line
    ) {
        self.logic = logic
        self.file = file
        self.line = line
    }
}
