//
//  ExampleApp.swift
//  Example
//
//  Created by Dan Berglund on 2021-05-12.
//

import SwiftELM

@main
struct App: ElmApp {
    struct Model {
        let number: Int
    }

    enum Message {
        case increase
        case decrease
    }

    let container = SwiftELM.sandbox(
        initial: .init(number: 10),
        view: { model in
            VStack(spacing: 30) {
                Button(onClick: Message.increase) {
                    Text("Increase")
                }
                Text<Message>("Current: \(model.number)")
                Button(onClick: Message.decrease) {
                    Text("Decrease")
                }
            }
        },
        update: { (message: Message, model: Model) in
            switch message {
            case .increase:
                return .init(number: model.number + 1)
            case .decrease:
                return .init(number: model.number - 1)
            }
        }
    )
}
