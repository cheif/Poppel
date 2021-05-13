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
    public func render(_ sink: @escaping (Message) -> Void) -> SwiftUI.Text {
        .init(text)
    }
}

public struct TupleComponent<Message, Content: View>: Component {
    let render: (@escaping (Message) -> Void) -> Content

    public func render(_ sink: @escaping (Message) -> Void) -> Content {
        self.render(sink)
    }
}

@resultBuilder
public struct ComponentBuilder {
    public static func buildBlock<C0, Message>(_ c0: C0) -> TupleComponent<Message, TupleView<(C0.Content)>> where C0: Component, C0.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink)))
        })
    }

    public static func buildBlock<C0, C1, Message>(_ c0: C0, _ c1: C1) -> TupleComponent<Message, TupleView<(C0.Content, C1.Content)>> where C0: Component, C1: Component, C0.Message == Message, C1.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink)))
        })
    }

    public static func buildBlock<C0, C1, C2, Message>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleComponent<Message, TupleView<(C0.Content, C1.Content, C2.Content)>> where C0: Component, C1: Component, C2: Component, C0.Message == Message, C1.Message == Message, C2.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink), c2.render(sink)))
        })
    }

    #warning("TODO: Continue with more buildBlocks")
}

public struct VStack<Content>: Component where Content: Component {
    public typealias Message = Content.Message

    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let content: Content
    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ComponentBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    public func render(_ sink: @escaping (Content.Message) -> Void) -> SwiftUI.VStack<Content.Content> {
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

    public func render(_ sink: @escaping (Message) -> Void) -> SwiftUI.Button<Label> {
        .init(action: { sink(message)}, label: { label })
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
