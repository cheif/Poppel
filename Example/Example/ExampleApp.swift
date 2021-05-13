//
//  ExampleApp.swift
//  Example
//
//  Created by Dan Berglund on 2021-05-12.
//

import SwiftUI
import SwiftELM

struct Model {
    let number: Int
}

enum Message {
    case increse
}

let app = SwiftELM.sandbox(
    initial: Model(number: 10),
    view: { model in
        VStack(spacing: 30) {
            Button(onClick: Message.increse) {
                Text("Increase")
            }
            MyText<Message>("Current: \(model.number)")
        }
    },
    update: { (message: Message, model: Model) in
        switch message {
        case .increse:
            return .init(number: model.number + 1)
        }
    }
)


@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            app.body
        }
    }
}

struct ContentViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        app.body
    }
}
