//
//  ExampleApp.swift
//  Example
//
//  Created by Dan Berglund on 2021-05-12.
//

import SwiftUI
import SwiftELM

struct Model {
    let text: String
}

enum Message {
    case click
}

let app = SwiftELM.sandbox(
    initial: Model(text: "Hello world"),
    view: { model in
        Button(Text(model.text), onClick: Message.click)
    },
    update: { (message: Message, model: Model) in
        .init(text: String(model.text.dropLast()))
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
