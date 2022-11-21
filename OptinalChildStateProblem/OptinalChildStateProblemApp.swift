//
//  OptinalChildStateProblemApp.swift
//  OptinalChildStateProblem
//
//  Created by Cihan Kisakurek on 21.11.22.
//

import SwiftUI
import ComposableArchitecture

@main
struct OptinalChildStateProblemApp: App {
    let store = Store(initialState: AppDomain.State(), reducer: AppDomain())
                      
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
