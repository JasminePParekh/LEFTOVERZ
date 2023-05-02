//
//  LeftoverzApp.swift
//  Leftoverz
//
//  Created by Jasmine Parekh on 4/18/23.
//

import SwiftUI

@main
struct LeftoverzApp: App {
    var body: some Scene {
        WindowGroup {
            Views(classifier: ImageClassifier())
        }
    }
}
