import PlaygroundSupport
import Poppel

enum Message {
    case increase
    case decrease
}

let app = Poppel.sandbox(
    initial: 0,
    view: { number in
        VStack(spacing: 10) {
            Button(onClick: Message.increase) { Text("Increase (+)") }
            Text<Message>("Current: \(number)")
            Button(onClick: Message.decrease) { Text("Decrease (-)") }
        }
    },
    update: { message, current in
        switch message {
        case .increase:
            return current + 1
        case .decrease:
            return current - 1
        }
    })

PlaygroundPage.current.setLiveView(app)
