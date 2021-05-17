# Poppel
Poppel is a Swift framework for building apps, heavily inspired by [Elm](https://elm-lang.org).

## State of project
Right now this is mostly a PoC for myself, trying to learn more about both Elm and SwiftUI. I would not recommend it for production use.

# Building an app
The idea is to separate the app into a few distinct parts, the first of these are a `Model` that represents the applications current state, and this can be anything, an `enum`, a `struct` etc. 
Following the `Model` we have a `view`, which is just a function to create a visual representation of the `Model`, the view is constructed from various `Component`:s. A typical `Component` is a thin wrapper of a SwiftUI `View`, but adding support for sending a `Message`.
The final part of the app is `update`, which is `(Message, Model) -> Model`. The framework takes care of linking these together, so that a `Message` from the UI calls `update` and then updates the UI using `view` again.

This is of course a very simple app, without side-effects, side-effects are possible, but let's start with an example instead (also available as `Counter.playground` in the example project).

```swift
import PlaygroundSupport
import Poppel

enum Message {
    case increase
    case decrease
}

let app = Poppel.sandbox(
    initial: 0,
    view: { number in
        VStack(spacing: 10) {
            Button(onClick: Message.increase) { Text("Increase (+)") }
            Text<Message>("Current: \(number)")
            Button(onClick: Message.decrease) { Text("Decrease (-)") }
        }
    },
    update: { message, current in
        switch message {
        case .increase:
            return current + 1
        case .decrease:
            return current - 1
        }
    })

PlaygroundPage.current.setLiveView(app)
```

Here the UI has two buttons, which sends different messages to the runtime, these messages are then passed to `update` where they are used to generate a new `Model` (in this example `Model == Int`). This is a very simple example, but it should clarify how the flow of data in the application looks like.
