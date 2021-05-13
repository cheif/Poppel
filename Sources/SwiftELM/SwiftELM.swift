import SwiftUI

public protocol Component {
    associatedtype Message
    associatedtype Content: SwiftUI.View

    func render(_ sink: @escaping (Message) -> Void) -> Content
}


// Components that don't have any actions (AKA Message == Never) can just use SwiftUI-Views straight away
public protocol WrappedComponent: Component {}
public extension WrappedComponent where Self: SwiftUI.View {
    func render(_ sink: @escaping (Never) -> Void) -> Self {
        return self
    }
}

extension Text: WrappedComponent {}

public struct Button<Message, Label: View>: Component {
    let label: Label
    let message: Message
    public init(onClick message: Message, _ label: () -> Label) {
        self.message = message
        self.label = label()
    }

    public func render(_ sink: @escaping (Message) -> Void) -> some View {
        SwiftUI.Button(action: { sink(message)}, label: { label })
    }
}

public struct Sandbox<Model, C: Component> {
    private let stateContainer: StateContainer
    private let view: (Model) -> C
    private let update: (C.Message, Model) -> Model

    init(initial: Model, view: @escaping (Model) -> C, update: @escaping (C.Message, Model) -> Model) {
        stateContainer = .init(model: initial)
        self.view = view
        self.update = update
    }

    public var body: some View {
        Content(stateContainer: stateContainer, transform: { model in
            view(model).render({ message in
                stateContainer.model = update(message, model)
            })
        })
    }

    class StateContainer: ObservableObject {
        @Published var model: Model

        init(model: Model) {
            self.model = model
        }
    }

    struct Content: View {
        @ObservedObject var stateContainer: StateContainer
        let transform: (Model) -> C.Content

        var body: some View {
            transform(stateContainer.model)
        }
    }
}

public struct SwiftELM {
    public static func sandbox<Model, C: Component>(initial: Model, view: @escaping (Model) -> C, update: @escaping (C.Message, Model) -> Model) -> Sandbox<Model, C> {
        Sandbox(initial: initial, view: view, update: update)
    }
}
