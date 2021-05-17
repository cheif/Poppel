import SwiftUI

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
