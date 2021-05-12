import SwiftUI

public protocol Component {
    associatedtype Message
    associatedtype Content: SwiftUI.View

    var body: Content { get }
    var sink: ((Message) -> Void)? { get set }
}

public struct Text: Component {
    public typealias Message = Never
    public let body: SwiftUI.Text
    public init(_ text: String) {
        body = SwiftUI.Text(text)
    }
    public var sink: ((Message) -> Void)?
}

public struct Button<Message, Label: View>: Component {
    let content: Label
    let message: Message
    public init(_ content: Label, onClick message: Message) {
        self.content = content
        self.message = message
    }

    public var body: some View {
        SwiftUI.Button(action: { sink?(message) }, label: { content })
    }
    public var sink: ((Message) -> Void)?
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
            var view = view(model)
            view.sink = { message in
                stateContainer.model = update(message, model)
            }

            return view.body
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
