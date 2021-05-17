/// This file generates extension to our ComponentBuilder, to avoid having to write all combinations ourselves
import Stencil

let templateString =
"""
/// This file is generated, don't change anything inside if, change the template instead.
import SwiftUI

extension ComponentBuilder {
    {% for block in blocks %}
    public static func buildBlock<Message, {{ block.types|join:", " }}>({{ block.arguments|join:", " }}) ->
        TupleComponent<Message, TupleView<({{ block.content|join:", " }})>>
        where {{ block.whereClause|join:", " }} {
        TupleComponent(render: { sink in
            TupleView(({{ block.render|join:", " }}))
        })
    }
    {% endfor %}
}
"""

struct Block {
    let types: [String]
    let arguments: [String]
    let content: [String]
    let whereClause: [String]
    let render: [String]

    private init(components: [Int]) {
        types = components.map { "C\($0)" }
        arguments = components.map { "_ c\($0): C\($0)" }
        content = types.map { type in "\(type).Content" }
        whereClause = types.map { type in "\(type): Component, \(type).Message == Message" }
        render = components.map { "c\($0).render(sink)" }
    }

    init(components: Int) {
        self.init(components: Array(0..<components))
    }
}

let blocks = (2...10).map { Block(components: $0) }

let template = Template(templateString: templateString)
let result = try! template.render(["blocks": blocks])

print(result)

