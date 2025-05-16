//
//  ContentView.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import SwiftUI

struct MainScreen: View {
    @ObservedObject var viewModel: MainScreenViewModel
    @State private var searchText = ""
    
    var body: some View {
        SearchGrid(
            viewModel: viewModel.searchGridViewModel,
            searchText: $searchText,
            items: viewModel.state.results
        )
        .id(viewModel.state.redrawId)
        .padding(.horizontal, 16)
        .navigationTitle("보관함")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.action.showSearchSheet.send()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
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
