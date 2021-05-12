//
//  ExampleApp.swift
//  Example
//
//  Created by Dan Berglund on 2021-05-12.
//

import SwiftUI
import SwiftELM


@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text(SwiftELM.text)
    }
}

struct ContentViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
