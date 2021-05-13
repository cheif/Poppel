import SwiftUI

public protocol Component {
    associatedtype Message
    associatedtype Content: SwiftUI.View

    func render(_ sink: @escaping (Message) -> Void) -> Content
}

// This is needed since we e.g. need everything in a VStack to have the same Message, but it would be nice to solve it in some way so that we could mix in stuff that don't have messages (Message == Never) as well.
public struct MyText<Message>: Component {
    let text: String
    public init(_ text: String) {
        self.text = text
    }
    public func render(_ sink: @escaping (Message) -> Void) -> some View {
        SwiftUI.Text(text)
    }
}

// It would be really nice it we could do this more generic, but I can't understand what's happening in SwiftUI. Maybe reflection is the way to go?
public struct TwoTupleComponent<C0: Component, C1: Component>: Component where C0.Message == C1.Message {
    let c0: C0
    let c1: C1

    public func render(_ sink: @escaping (C0.Message) -> Void) -> some View {
        TupleView((c0.render(sink), c1.render(sink)))
    }
}

@resultBuilder
public struct ComponentBuilder {
    public static func buildBlock<C0>(_ c0: C0) -> C0 where C0: Component {
        c0
    }

    public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TwoTupleComponent<C0, C1> where C0: Component, C1: Component, C0.Message == C1.Message {
        TwoTupleComponent(c0: c0, c1: c1)
    }
}

public struct VStack<Content>: Component where Content: Component {
    public typealias Message = Content.Message
    public var sink: ((Content.Message) -> Void)?

    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let content: Content
    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ComponentBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    public func render(_ sink: @escaping (Content.Message) -> Void) -> some View {
        SwiftUI.VStack(alignment: alignment, spacing: spacing, content: { content.render(sink) })
    }
}

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
