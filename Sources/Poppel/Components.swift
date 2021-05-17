import SwiftUI

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

public struct Image<Message>: Component {
    let content: SwiftUI.Image
    init(content: SwiftUI.Image) {
        self.content = content
    }
    public init(uiImage: UIImage) {
        self.init(content: .init(uiImage: uiImage))
    }

    public func render(_ sink: @escaping (Message) -> Void) -> SwiftUI.Image {
        content
    }
}

extension Image {
    public func resizable(capInsets: EdgeInsets = .init(), resizingMode: SwiftUI.Image.ResizingMode = .stretch) -> Self {
        .init(content: content.resizable(capInsets: capInsets, resizingMode: resizingMode))
    }
}

@available(iOS 14.0, *)
public struct ProgressView<Message>: Component {
    public init() {}
    public func render(_ sink: @escaping (Message) -> Void) -> SwiftUI.ProgressView<EmptyView, EmptyView>  {
        SwiftUI.ProgressView()
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

    public static func buildBlock<C0, C1, C2, C3, Message>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> TupleComponent<Message, TupleView<(C0.Content, C1.Content, C2.Content, C3.Content)>>
    where C0: Component, C1: Component, C2: Component, C3: Component, C0.Message == Message, C1.Message == Message, C2.Message == Message, C3.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink), c2.render(sink), c3.render(sink)))
        })
    }

    #warning("TODO: Continue with more buildBlocks")
}

public struct EitherComponent<Message, C0: Component, C1: Component>: Component where C0.Message == Message, C1.Message == Message {
    let c0: C0?
    let c1: C1?

    public func render(_ sink: @escaping (Message) -> Void) -> TupleView<(C0.Content?, C1.Content?)> {
        TupleView((c0?.render(sink), c1?.render(sink)))
    }
}

extension ComponentBuilder {
    public static func buildEither<C0: Component, C1: Component>(first component: C0) -> EitherComponent<C0.Message, C0, C1> where C0.Message == C1.Message {
        EitherComponent(c0: component, c1: nil)
    }

    public static func buildEither<C0: Component, C1: Component>(second component: C1) -> EitherComponent<C0.Message, C0, C1> where C0.Message == C1.Message {
        EitherComponent(c0: nil, c1: component)
    }
}

public struct VStack<Message, Content: Component>: Component where Content.Message == Message {

    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let content: Content
    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ComponentBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    public func render(_ sink: @escaping (Message) -> Void) -> SwiftUI.VStack<Content.Content> {
        SwiftUI.VStack(alignment: alignment, spacing: spacing, content: { content.render(sink) })
    }
}
