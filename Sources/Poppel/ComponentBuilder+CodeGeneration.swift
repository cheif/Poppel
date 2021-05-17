/// This file is generated, don't change anything inside if, change the template instead.
import SwiftUI

extension ComponentBuilder {
    
    public static func buildBlock<Message, C0, C1>(_ c0: C0, _ c1: C1) ->
        TupleComponent<Message, TupleView<(C0.Content, C1.Content)>>
        where C0: Component, C0.Message == Message, C1: Component, C1.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink)))
        })
    }
    
    public static func buildBlock<Message, C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) ->
        TupleComponent<Message, TupleView<(C0.Content, C1.Content, C2.Content)>>
        where C0: Component, C0.Message == Message, C1: Component, C1.Message == Message, C2: Component, C2.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink), c2.render(sink)))
        })
    }
    
    public static func buildBlock<Message, C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) ->
        TupleComponent<Message, TupleView<(C0.Content, C1.Content, C2.Content, C3.Content)>>
        where C0: Component, C0.Message == Message, C1: Component, C1.Message == Message, C2: Component, C2.Message == Message, C3: Component, C3.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink), c2.render(sink), c3.render(sink)))
        })
    }
    
    public static func buildBlock<Message, C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) ->
        TupleComponent<Message, TupleView<(C0.Content, C1.Content, C2.Content, C3.Content, C4.Content)>>
        where C0: Component, C0.Message == Message, C1: Component, C1.Message == Message, C2: Component, C2.Message == Message, C3: Component, C3.Message == Message, C4: Component, C4.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink), c2.render(sink), c3.render(sink), c4.render(sink)))
        })
    }
    
    public static func buildBlock<Message, C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) ->
        TupleComponent<Message, TupleView<(C0.Content, C1.Content, C2.Content, C3.Content, C4.Content, C5.Content)>>
        where C0: Component, C0.Message == Message, C1: Component, C1.Message == Message, C2: Component, C2.Message == Message, C3: Component, C3.Message == Message, C4: Component, C4.Message == Message, C5: Component, C5.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink), c2.render(sink), c3.render(sink), c4.render(sink), c5.render(sink)))
        })
    }
    
    public static func buildBlock<Message, C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) ->
        TupleComponent<Message, TupleView<(C0.Content, C1.Content, C2.Content, C3.Content, C4.Content, C5.Content, C6.Content)>>
        where C0: Component, C0.Message == Message, C1: Component, C1.Message == Message, C2: Component, C2.Message == Message, C3: Component, C3.Message == Message, C4: Component, C4.Message == Message, C5: Component, C5.Message == Message, C6: Component, C6.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink), c2.render(sink), c3.render(sink), c4.render(sink), c5.render(sink), c6.render(sink)))
        })
    }
    
    public static func buildBlock<Message, C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) ->
        TupleComponent<Message, TupleView<(C0.Content, C1.Content, C2.Content, C3.Content, C4.Content, C5.Content, C6.Content, C7.Content)>>
        where C0: Component, C0.Message == Message, C1: Component, C1.Message == Message, C2: Component, C2.Message == Message, C3: Component, C3.Message == Message, C4: Component, C4.Message == Message, C5: Component, C5.Message == Message, C6: Component, C6.Message == Message, C7: Component, C7.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink), c2.render(sink), c3.render(sink), c4.render(sink), c5.render(sink), c6.render(sink), c7.render(sink)))
        })
    }
    
    public static func buildBlock<Message, C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) ->
        TupleComponent<Message, TupleView<(C0.Content, C1.Content, C2.Content, C3.Content, C4.Content, C5.Content, C6.Content, C7.Content, C8.Content)>>
        where C0: Component, C0.Message == Message, C1: Component, C1.Message == Message, C2: Component, C2.Message == Message, C3: Component, C3.Message == Message, C4: Component, C4.Message == Message, C5: Component, C5.Message == Message, C6: Component, C6.Message == Message, C7: Component, C7.Message == Message, C8: Component, C8.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink), c2.render(sink), c3.render(sink), c4.render(sink), c5.render(sink), c6.render(sink), c7.render(sink), c8.render(sink)))
        })
    }
    
    public static func buildBlock<Message, C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) ->
        TupleComponent<Message, TupleView<(C0.Content, C1.Content, C2.Content, C3.Content, C4.Content, C5.Content, C6.Content, C7.Content, C8.Content, C9.Content)>>
        where C0: Component, C0.Message == Message, C1: Component, C1.Message == Message, C2: Component, C2.Message == Message, C3: Component, C3.Message == Message, C4: Component, C4.Message == Message, C5: Component, C5.Message == Message, C6: Component, C6.Message == Message, C7: Component, C7.Message == Message, C8: Component, C8.Message == Message, C9: Component, C9.Message == Message {
        TupleComponent(render: { sink in
            TupleView((c0.render(sink), c1.render(sink), c2.render(sink), c3.render(sink), c4.render(sink), c5.render(sink), c6.render(sink), c7.render(sink), c8.render(sink), c9.render(sink)))
        })
    }
    
}
