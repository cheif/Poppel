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
        let showOther: Bool
    }

    enum Message {
        case increase
        case decrease
        case other
    }

    let container = SwiftELM.sandbox(
        initial: .init(number: 10, showOther: false),
        view: { model in
                VStack(spacing: 30) {
                    if model.showOther {
                        Text<Message>("This is other!")
                    } else {
                        Button(onClick: Message.increase) {
                            Text("Increase")
                        }
                        Text<Message>("Current: \(model.number)")
                        Button(onClick: Message.decrease) {
                            Text("Decrease")
                        }
                        Button(onClick: Message.other) {
                            Text("Switch")
                        }
                }
            }
        },
        update: { (message: Message, model: Model) in
            switch message {
            case .increase:
                return .init(number: model.number + 1, showOther: model.showOther)
            case .decrease:
                return .init(number: model.number - 1, showOther: model.showOther)
            case .other:
                return .init(number: model.number, showOther: true)
            }
        }
    )
}
