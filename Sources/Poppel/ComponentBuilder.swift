import SwiftUI

@resultBuilder
public struct ComponentBuilder {
    public static func buildBlock<Message>() -> EmptyComponent<Message> {
        EmptyComponent()
    }

    public static func buildBlock<C0>(_ c0: C0) -> C0 {
        c0
    }
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
