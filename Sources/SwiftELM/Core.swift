import SwiftUI

public protocol Component {
    associatedtype Message
    associatedtype Content: SwiftUI.View

    func render(_ sink: @escaping (Message) -> Void) -> Content
}

public typealias Command<Message> = (@escaping (Message) -> Void) -> Void

public struct AppContainer<Model, Message, Content: Component>: View where Content.Message == Message {
    private let container: ModelContainer<Model, Message>
    private let view: (Model) -> Content

    init(initial: Model, command: @escaping Command<Message>, view: @escaping (Model) -> Content, update: @escaping (Content.Message, Model) -> (Model, Command<Message>)) {
        self.container = .init(model: initial, update: update)
        container.run(command)
        self.view = view
    }

    public var body: some View {
        RenderContainer(container: container, transform: { model in
            view(model).render(container.send)
        })
    }

    class ModelContainer<Model, Message>: ObservableObject {
        @Published var model: Model
        let update: (Message, Model) -> (Model, Command<Message>)

        init(model: Model, update: @escaping (Message, Model) -> (Model, Command<Message>)) {
            self.model = model
            self.update = update
        }

        func run(_ command: Command<Message>) {
            #warning("Do we need some sort of syncronization here, since we might have multiple commands running?")
            command(send)
        }

        func send(_ message: Message) {
            let (model, command) = update(message, model)
            DispatchQueue.main.async {
                self.model = model
            }
            run(command)
        }
    }

    struct RenderContainer: View {
        @ObservedObject var container: ModelContainer<Model, Message>
        let transform: (Model) -> Content.Content

        var body: some View {
            transform(container.model)
        }
    }
}

@available(iOS 14.0, *)
public protocol ElmApp: App {
    associatedtype Model
    associatedtype Message
    associatedtype Content: Component where Content.Message == Message
    var container: AppContainer<Model, Message, Content> { get }
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
    public static func sandbox<Model, Message, C: Component>(
        initial: Model,
        @ComponentBuilder view: @escaping (Model) -> C,
        update: @escaping (Message, Model) -> Model
    ) -> AppContainer<Model, Message, C> where C.Message == Message {
        AppContainer(initial: initial, command: { _ in}, view: view, update: { message, model in (update(message, model), { _ in}) })
    }

    public static func app<Model, Message, C: Component>(
        initial: Model,
        command: @escaping Command<Message> = {_ in},
        @ComponentBuilder view: @escaping (Model) -> C,
        update: @escaping (Message, Model) -> (Model, Command<Message>)
    ) -> AppContainer<Model, Message, C> where C.Message == Message {
        AppContainer(initial: initial, command: command, view: view, update: update)
    }
}
