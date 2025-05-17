//
//  SearchAndSaveApp.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import SwiftUI

@main
struct SearchAndSaveApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainScreen(viewModel: MainScreenViewModel())
            }
        }
    }
}
