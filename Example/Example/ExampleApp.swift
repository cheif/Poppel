//
//  ExampleApp.swift
//  Example
//
//  Created by Dan Berglund on 2021-05-12.
//

import Foundation
import Poppel
import UIKit

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
struct App: Poppel.App {
    struct Model {
        let number: Int
        let showOther: Bool
        let image: ImageStatus

        enum ImageStatus {
            case loading
            case loaded(UIImage)
            case error
        }
    }

    enum Message {
        case increase
        case decrease
        case other
        case imageUpdate(Model.ImageStatus)
    }

    let container = Poppel.app(
        initial: .init(number: 10, showOther: false, image: .loading),
        view: { model in
            if model.showOther {
                VStack(spacing: 30) {
                    Text<Message>("This is other!")
                    switch model.image {
                    case .loading:
                        ProgressView<Message>()
                    case .loaded(let image):
                        Image<Message>(uiImage: image)
                            .resizable()
                    case .error:
                        Text<Message>("Error")
                    }
                }
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
                return (.init(number: model.number + 1, showOther: model.showOther, image: model.image), { _ in})
            case .decrease:
                return (.init(number: model.number - 1, showOther: model.showOther, image: model.image), { _ in})
            case .other:
                return (.init(number: model.number, showOther: true, image: model.image),
                        URLSession.shared.command(with: URL(string: "https://www.stonefactory.se/pub_images/original/plant-japanskt-prydnadskorsbar-prunus-kanzan-100-120-cm-stonefactory.se.jpg?extend=copy&width=1440&method=fit&height=1440&type=webp")!) { data, _, _ in
                            Message.imageUpdate(data.flatMap(UIImage.init).map(Model.ImageStatus.loaded) ?? .error)
                        })
            case .imageUpdate(let imageStatus):
                return (.init(number: model.number, showOther: true, image: imageStatus), { _ in})
            }
        }
    )
}
