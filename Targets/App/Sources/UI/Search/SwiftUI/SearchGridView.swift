//
//  SearchGrid.swift
//  SearchAndSave
//
//  Created by nakcheon.jung on 5/16/25.
//

import SwiftUI
import Kingfisher
import EnvironmentKit
import domainKit

struct SearchGrid: View {
    @ObservedObject var viewModel: SearchGridViewModel
    @Binding var searchText: String
    let items: [SearchedResultInfo]
    
    enum Constants {
        static let sideMargin: CGFloat = 16
    }

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
                        LazyVStack(spacing: 8) {
                            ForEach(leftColumn) { item in
                                GridCard(
                                    viewModel: viewModel,
                                    item: item,
                                    index: items.firstIndex(of: item)
                                )
                            }
                        }
                        .frame(width: calculateCellWidth(geometry))
                        LazyVStack(spacing: 8) {
                            ForEach(rightColumn) { item in
                                GridCard(
                                    viewModel: viewModel,
                                    item: item,
                                    index: items.firstIndex(of: item)
                                )
                            }
                        }
                        .frame(width: calculateCellWidth(geometry))
                    }
                    .padding(.horizontal, Constants.sideMargin)
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
    
    private func calculateCellWidth(_ geometry: GeometryProxy) -> CGFloat {
        let width = (geometry.size.width - (Constants.sideMargin * 2)) / 2
        if width < 0 {
            return 0
        }
        return width
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
        .cornerRadius(16)
    }
    
    @ViewBuilder
    private var imageView: some View {
        KFImage(URL(string: item.thumbnail))
            .cacheOriginalImage(true)
            .backgroundDecode(true)
            .downloadPriority(0)
            .placeholder {
                Asset.resourceIcError.swiftUIImage
                    .font(.largeTitle)
                    .opacity(0.3)
            }
            .retry(maxCount: 3, interval: .seconds(5))
            .onFailure { error in
                DLog.log("Image Loading Error : \(error)")
            }
            .resizable()
            .diskCacheExpiration(.days(7))
            .memoryCacheExpiration(.seconds(300))
            .aspectRatio(contentMode: .fill)
            .cornerRadius(16)
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
                    Text(I18n.image)
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
}
