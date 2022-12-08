import Foundation

public protocol ValidInitialStep: Step {} // given
public protocol ValidAfterGiven_BeforeWhen: Step {} // and
public protocol ValidAfterGiven_BeforeThen: Step {} // when
public protocol ValidAfterWhen_BeforeThen: Step {} // and
public protocol ValidAfterWhen: Step {} // then
public protocol ValidAfterThen: Step {} // and

@resultBuilder
public enum StepsBuilder {

    // This ensures that the first step must be a Given step.
    public static func buildPartialBlock(first step: ValidInitialStep) -> ValidInitialStep { add(description: "Given", to: step) }

    // These ensure that the correct step follows a previous step.
    // For example it won't sllow you to put a second Given anywhere in the step, nor will it allow you to put a Then before a When, etc.
    // These also power allowing you to have unlimited number of And steps after Given, When and Then.
    public static func buildPartialBlock(accumulated previous: ValidInitialStep, next: ValidAfterGiven_BeforeWhen) -> ValidAfterGiven_BeforeWhen { add(previous, to: next, with: "And (after Given)") } // and after given
    public static func buildPartialBlock(accumulated previous: ValidAfterGiven_BeforeWhen, next: ValidAfterGiven_BeforeWhen) -> ValidAfterGiven_BeforeWhen { add(previous, to: next, with: "And (after Given)") } // subsequent ands after given

    public static func buildPartialBlock(accumulated previous: ValidAfterGiven_BeforeWhen, next: ValidAfterGiven_BeforeThen) -> ValidAfterGiven_BeforeThen { add(previous, to: next, with: "When") } // when after and
    public static func buildPartialBlock(accumulated previous: ValidInitialStep, next: ValidAfterGiven_BeforeThen) -> ValidAfterGiven_BeforeThen { add(previous, to: next, with: "When") } // when after given
    public static func buildPartialBlock(accumulated previous: ValidAfterGiven_BeforeThen, next: ValidAfterWhen_BeforeThen) -> ValidAfterWhen_BeforeThen { add(previous, to: next, with: "And (after When)") } // and after when
    public static func buildPartialBlock(accumulated previous: ValidAfterWhen_BeforeThen, next: ValidAfterWhen_BeforeThen) -> ValidAfterWhen_BeforeThen { add(previous, to: next, with: "And (after When)") } // subsequent ands after when

    public static func buildPartialBlock(accumulated previous: ValidAfterWhen_BeforeThen, next: ValidAfterWhen) -> ValidAfterWhen { add(previous, to: next, with: "Then") } // then after and
    public static func buildPartialBlock(accumulated previous: ValidAfterGiven_BeforeThen, next: ValidAfterWhen) -> ValidAfterWhen { add(previous, to: next, with: "Then") } // then after when
    public static func buildPartialBlock(accumulated previous: ValidAfterWhen, next: ValidAfterThen) -> ValidAfterThen { add(previous, to: next, with: "And (after Then)") } // and after then
    public static func buildPartialBlock(accumulated previous: ValidAfterThen, next: ValidAfterThen) -> ValidAfterThen { add(previous, to: next, with: "And (after Then)") } // subsequent ands after then

    // These ensure that the final step is either a Then, or and And that follows a Then.
    // This won't allow Given, When or any And that doesn't follow a Then.
    public static func buildFinalResult(_ component: ValidAfterWhen) -> ValidAfterWhen { component } // final then
    public static func buildFinalResult(_ component: ValidAfterThen) -> ValidAfterThen { component } // final and after then or subsequent ands after then

    private static func add<Previous: Step, Next: Step>(
        _ previous: Previous,
        to next: Next,
        with description: String
    ) -> Next {
        var next = next
        next.previous = previous
        next.index = previous.index + 1
        return add(description: description, to: next)
    }

    private static func add<T: Step>(description: String, to step: T) -> T {
        var step = step
        step.description = description
        return step
    }
}
