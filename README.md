# BDDSwift

BDDSwift is a type-safe, compiler-enforced implementation of the BDD Given/When/Then syntax for writing descriptive, 
human-readable XCTest tests.

BDDSwift uses Swift resuiltBuilders to enforce the order of the steps in a scenario; a scenario must start with a Given step, 
must include a When step, and must end with a Then step (or an And that follows a Then step).

For example this is valid:

```swift
Scenario("My amazing scenario") {
    Given(the: appIsInSomeState)
    When(I: performSomeAction)
    Then(the: appIsInADifferentState)
}
``` 

And so is this:

```swift
Scenario("My amazing scenario") {
    Given(the: appIsInSomeState)
    And(somethingElseIsSetUp)
    When(I: performSomeAction)
    And(I: performSomeOtherAction)
    Then(the: appIsInADifferentState)
    And(someOtherStateHasChanged)
}
```

But this isn't valid, and won't compile:

```swift
Scenario("My amazing scenario") {
    When(the: appIsInSomeState)
    Given(I: performSomeAction)
    Then(the: appIsInADifferentState)
}
```

And nor is this:

```swift
Scenario("My amazing scenario") {
    Given(the: appIsInSomeState)
    And(I: performSomeAction)
    And(the: appIsInADifferentState)
}
```

Each step takes a function as an argument which is executed by the scenario in the correct order as the steps.

To make the step read more like a sentence you can omit the `()` for functions that don't take parameters:

```swift
When(I: tapAButton)
```

But if you need to call a function that takes parameters each step has an autoclosure that keeps everything readable: 

```swift
When(I: select(tab: .profile))
```

If you really need to, you can also pass a closure:

```swift
When {
    // Some code here
}
```

However I recommend that you keep things readable and pop all your code in nicely named functions, which also helps with reusability, 
especially in UI tests.

## Usage

First start by creating a `Scenario` in a test function, giving it a description:

```swift
func test_happyPath() {
    Scenario("Launching the app and logging in shows home screen") {
        // This won't compile yet because you have to add some steps!
    }
}
```

Then build up the steps that the scenario covers:

 - Start with a `Given` step; this step is meant for describing some initial setup or state. 
 - Add a `When` step; this step is meant for describing something that happens.
 - Finish with a `Then` step; this step is meant for describing what should happen or what state things should be after the When step happens.
 
```swift
func test_happyPath() {
    Scenario("Launching the app and logging in shows home screen") {
        Given(the: appIsLaunched)
        When(I: logIn)
        Then(I: see(.homeScreen))
    }
}

private func appIsLaunched() {
    // Code to launch the app
}

private func logIn() {
    // Code to log in
}

private func see(_ screen: Screen) {
    // Code to assert home screen is showing
}
```
 
There should only be one `Given`, `When` and `Then` step per-scenario (in that order, otherwise it won't compile!), 
however you can add `And` steps after each if you need to add extra context, wait for a certain state, or need to 
perform some other work that is important to each stage of the scenario:
 
```swift
func test_happyPath() {
    Scenario("Launching the app and logging in shows home screen") {
        Given(the: appIsLaunched)
        And(I: see(.loginScreen))
        When(I: logIn)
        Then(I: see(.homeScreen))
        And(the: lastAnalyticsEventsTracked(are: .viewLoginScreen, .userLogIn, .viewHomeScreen))
    }
}

private func appIsLaunched() {
    // Code to launch the app
}

private func logIn() {
    // Code to log in
}

private func see(_ screen: Screen) {
    // Code to assert home screen is showing
}

private func lastAnalyticsEventsTracked(are events: AnalyticsEvent...) {
    // Code to assert correct analytics have been tracked
}
```

Notice in the code examples above, we're using a mix of passing a function by reference (i.e. without writing the `()`) and calling 
functions that take parameters, all while still maintaining strong readability.

I recommend passing a function by reference wherever you're using function that doesn't take arguments, this is the most readable way of
writing steps, but BDDSwift still makes things readable for cases when you're calling a function that takes parameters by using _autoclosures_.

> Fun fact: Autoclosures wrap your code in invisible curly braces, and it's how you can pass a function into the step initialiser without wrapping in `{ ... }`!

Additionally, you may notice that the initializer parameters give you the option of `the:`, `I:` etc. This means you can remove these words 
from your individual function signatures, but it's up to you if you want prefer to add this to the function name yourself like so:

```
Given(theAppIsLaunched)
When(iLogIn)
Then(iSeeScreen(.profile))
```

But this has a tendency to read less like a normal sentence, which is one of the main benefits of BDD; human-readable descriptions of behaviours.

## Integration with XCUI tests

If you use BDDSwift in XCUI tests then you will automatically get extra logs added to your test logs in the form of XCTActivities which helps you 
pinpoint where a failure occurred and the steps that were taken to get there.

Since it's very common (and recommended for parallel tests) to _have one long test function per test case_ for XCUI tests, BDDSwift also helps 
you break up long tests into logical scenarios which makes them easier to read, extend and maintain.

```swift
func test_happyPath() {
    Scenario("Launching the app and logging in shows home screen") {
        Given(the: appIsLaunched)
        And(I: see(.loginScreen))
        When(I: logIn)
        Then(I: see(.homeScreen))
    }
    Scenario("Tapping on Settings tab shows settings") {
        Given(I: see(.homeScreen))
        When(I: tap(tab: .settings))
        Then(I: see(.settingsScreen))
    }
    Scenario("Tapping on Log Out button shows log in screen") {
        Given(I: see(.settingsScreen))
        When(I: tap(.logout))
        Then(I: see(.loginScreen))
    }
}
```
