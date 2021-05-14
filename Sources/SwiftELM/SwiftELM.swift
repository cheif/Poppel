import SwiftUI

public protocol Component {
    associatedtype Message
    associatedtype Content: SwiftUI.View

    func render(_ sink: @escaping (Message) -> Void) -> Content
}

// This is needed since we e.g. need everything in a VStack to have the same Message, but it would be nice to solve it in some way so that we could mix in stuff that don't have messages (Message == Never) as well.
public struct Text<Message>: Component {
    let text: String
    public init(_ text: String) {
        self.text = text
    }
    public func render(_ sink: @escaping (Message) -> Void) -> SwiftUI.Text {
        .init(text)
    }
}

public struct EmptyComponent<Message>: Component {
    public init() {}
    public func render(_ sink: @escaping (Message) -> Void) -> some View {
        SwiftUI.EmptyView()
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

public struct Button<Message, Label: Component>: Component where Label.Message == Message {
    let label: Label
    let message: Message
    public init(onClick message: Message, _ label: () -> Label) {
        self.message = message
        self.label = label()
    }

    public func render(_ sink: @escaping (Message) -> Void) -> SwiftUI.Button<Label.Content> {
        .init(action: { sink(message)}, label: { label.render(sink) })
    }
}

public struct AppContainer<Model, Content: Component>: View {
    private let container: ModelContainer<Model>
    private let view: (Model) -> Content
    private let update: (Content.Message, Model) -> Model

    init(initial: Model, view: @escaping (Model) -> Content, update: @escaping (Content.Message, Model) -> Model) {
        self.container = .init(model: initial)
        self.view = view
        self.update = update
    }

    public var body: some View {
        RenderContainer(container: container, transform: { model in
            view(model).render { message in
                container.model = update(message, container.model)
            }
        })
    }

    class ModelContainer<Model>: ObservableObject {
        @Published var model: Model

        init(model: Model) {
            self.model = model
        }
    }

    struct RenderContainer: View {
        @ObservedObject var container: ModelContainer<Model>
        let transform: (Model) -> Content.Content

        var body: some View {
            transform(container.model)
        }
    }
}

@available(iOS 14.0, *)
public protocol ElmApp: App {
    associatedtype Content: Component
    associatedtype Model
    var container: AppContainer<Model, Content> { get }
}

@available(iOS 14.0, *)
extension ElmApp {
    public var body: some Scene {
        WindowGroup {
            container
        }
    }
}

public struct SwiftELM {
    public static func sandbox<Model, C: Component>(initial: Model, view: @escaping (Model) -> C, update: @escaping (C.Message, Model) -> Model) -> AppContainer<Model, C> {
        AppContainer(initial: initial, view: view, update: update)
    }
}
