//
//  SearchGrid.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/16/25.
//

import SwiftUI
import Kingfisher

struct SearchGrid: View {
    @ObservedObject var viewModel: SearchGridViewModel
    @Binding var searchText: String
    let items: [SearchedResultInfo]

    var leftColumn: [SearchedResultInfo] {
        items.enumerated().compactMap { index, item in
            index % 2 == 0 ? item : nil
        }
    }
    
    var rightColumn: [SearchedResultInfo] {
        items.enumerated().compactMap { index, item in
            index % 2 != 0 ? item : nil
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack(spacing: 0) {
                    HStack(alignment: .top, spacing: 8) {
                        VStack(spacing: 8) {
                            ForEach(leftColumn) { item in
                                GridCard(
                                    viewModel: viewModel,
                                    item: item,
                                    index: items.firstIndex(of: item)
                                )
                            }
                        }
                        .frame(width: geometry.size.width / 2)
                        VStack(spacing: 8) {
                            ForEach(rightColumn) { item in
                                GridCard(
                                    viewModel: viewModel,
                                    item: item,
                                    index: items.firstIndex(of: item)
                                )
                            }
                        }
                        .frame(width: geometry.size.width / 2)
                    }
                    if !viewModel.state.allListLoaded {
                        HStack(spacing: 0) {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding(.top, 20)
                        .onAppear {
                            viewModel.action.loadMoreSearchedList.send(searchText)
                        }
                    }
                }
            }
        }
    }
}

private struct GridCard: View {
    @ObservedObject var viewModel: SearchGridViewModel
    let item: SearchedResultInfo
    let index: Int?
    @State var disappared = false
    @State var hide = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack {
                imageView
                bookmarkView
                bottomInfoView
                    .padding(.bottom, 8)
            }
        }
        .background(.gray.opacity(0.5))
        .overlay(GeometryReader { reader in
            Color.clear.preference(
                key: CellFrameKey.self,
                value: reader.frame(in: .global)
            )
        })
        .onPreferenceChange(CellFrameKey.self) { rect in
            if rect.origin.y + rect.height + rect.origin.y < 0 {
                disappared = true
            } else {
                disappared = false
            }
        }
        .onChange(of: disappared) { value in
            withAnimation(.easeIn(duration: 0.1)) {
                hide = value
            }
        }
        .opacity(hide ? 0 : 1)
    }
    
    @ViewBuilder
    private var imageView: some View {
        KFImage(URL(string: item.thumbnail))
            .cacheOriginalImage(true)
            .backgroundDecode(true)
            .downloadPriority(0)
            .placeholder {
                Image(systemName: "doc.text.image.fill")
                    .font(.largeTitle)
                    .opacity(0.3)
            }
            .retry(maxCount: 3, interval: .seconds(5))
            .onFailure { error in
                Logger.log("Image Loading Error : \(error)")
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    @ViewBuilder
    private var bookmarkView: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                if viewModel.containsBookmark(info: item) {
                    Button {
                        viewModel.action.removeFromBookmark.send(item)
                    } label: {
                        Image(systemName: "bookmark.fill")
                            .padding(8)
                    }
                    .id(viewModel.state.redrawId)
                } else {
                    Button {
                        viewModel.action.bookmark.send(item)
                    } label: {
                        Image(systemName: "bookmark")
                            .padding(8)
                    }
                    .id(viewModel.state.redrawId)
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private var bottomInfoView: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Text(item.dateString)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(3)
                    .background(Color.black.opacity(0.9))
                    .padding(.leading, 8)
                Spacer()
            }
            if item.playTime != nil {
                HStack {
                    Text(item.formatPlayTime)
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(3)
                        .background(Color.black.opacity(0.9))
                        .padding(.leading, 8)
                    Spacer()
                }
            }
            if item.imageUrl != nil {
                HStack {
                    Text("image")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .padding(3)
                        .background(Color.black.opacity(0.9))
                        .padding(.leading, 8)
                    Spacer()
                }
            }
        }
    }
    
    private struct CellFrameKey: PreferenceKey {
        static var defaultValue: CGRect = .zero
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
            value = nextValue()
        }
    }
}
