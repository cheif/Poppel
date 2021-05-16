//
//  ExampleApp.swift
//  Example
//
//  Created by Dan Berglund on 2021-05-12.
//

import Foundation
import SwiftELM

extension URLSession {
    public func command<Message>(with url: URL, transform: @escaping (Data?, URLResponse?, Error?) -> Message) -> Command<Message> {
        return { callback in
            self
                .dataTask(with: url, completionHandler: { callback(transform($0, $1, $2)) })
                .resume()
        }
    }
}

@main
struct App: ElmApp {
    struct Model {
        let number: Int
        let showOther: Bool
        let text: String?
    }

    enum Message {
        case increase
        case decrease
        case other
        case gotText(String?)
    }

    let container = SwiftELM.app(
        initial: .init(number: 10, showOther: false, text: nil),
        view: { model in
            if model.showOther {
                Text<Message>("This is other!")
                Text<Message>(model.text ?? "Loading...")
            } else {
                VStack(spacing: 30) {
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
                return (.init(number: model.number + 1, showOther: model.showOther, text: model.text), { _ in})
            case .decrease:
                return (.init(number: model.number - 1, showOther: model.showOther, text: model.text), { _ in})
            case .other:
                return (.init(number: model.number, showOther: true, text: model.text),
                        URLSession.shared.command(with: URL(string: "https://elm-lang.org/assets/public-opinion.txt")!, transform: { data, _, _ in
                            Message.gotText(data.flatMap { String(data: $0, encoding: .utf8) })
                        }))
            case .gotText(let text):
                return (.init(number: model.number, showOther: true, text: text), { _ in})
            }
        }
    )
}
