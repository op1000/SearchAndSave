//
//  SearchSheet.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/15/25.
//

import SwiftUI

class SearchSheetViewController: UIHostingController<SearchSheet> {
    public override init(rootView: SearchSheet) {
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Logger.log(#function)
    }
}

struct SearchSheet: View {
    @ObservedObject var viewModel: SearchSheetViewModel
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            SearchBar(viewModel: viewModel.searchbarViewModel, text: $searchText)
                .padding(.vertical, 20)
            if viewModel.state.results.isEmpty {
                Spacer()
            } else {
                SearchGrid(
                    viewModel: viewModel,
                    searchText: $searchText,
                    items: viewModel.state.results
                )
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    SearchSheet(viewModel: SearchSheetViewModel())
}

