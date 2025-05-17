//
//  ContentView.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import SwiftUI

struct MainScreen: View {
    @ObservedObject var viewModel: MainScreenViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .navigationTitle("보관함")
        .onAppear {
            viewModel.action.onAppear.send()
        }
    }
}

#Preview {
    NavigationView {
        MainScreen(viewModel: MainScreenViewModel())
    }
}
