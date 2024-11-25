//
//  RepositoryListView.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import SwiftUI

struct RepositoryListView: View {
    @StateObject private var viewModel: RepositoryListViewModel
    @State private var gridColumnType: GridColumnType = .oneViewInRow
    @Environment(\.dismiss) private var dismiss
    
    private var gridLayout: [GridItem] {
        let gridItem = GridItem(.flexible(minimum: 70), spacing: 5)
        return Array(repeating: gridItem, count: gridColumnType.rawValue)
    }
    
    init(userModel: UserSearchModel, container: DependencyContainer) {
        _viewModel = StateObject(wrappedValue: RepositoryListViewModel(
            networkService: container.networkService,
            storageService: container.localStorageService,
            networkMonitoringService: container.networkMonitoringService,
            repositoryOwnerModel: userModel))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                contentView()
                    .navigationBarTitleDisplayMode(.inline)
                
                switch viewModel.viewState {
                case .idle, .hideLoading:
                    Color.clear
                case .showLoading:
                    loadingView
                case .showEmptyView:
                    Text("There Is No Repository")
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Repository List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            gridColumnType.changeGridColumnSize()
                        } label: {
                            gridColumnType.gridColumImage
                                .foregroundStyle(Color.blue)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.black)
                    }
                }
            }
        }.onAppear {
            viewModel.getRepositories()
        }.alert(NSLocalizedString(
            "Repository Not Found",
            comment: viewModel.errorMessage), 
                isPresented: .init(
                    get: { !viewModel.errorMessage.isEmpty },
                    set: { if !$0 { viewModel.errorMessage = "" }}
                )) {
                    Button("Ok", role: .cancel) {
                        dismiss()
                    }
                }
    }
    
    private var loadingView: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            ProgressView(label: {
                Text("Loading")
                    .foregroundStyle(Color.white)
            }).tint(Color.white)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.85))
                }
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        ScrollView {
            LazyVGrid(columns: gridLayout) {
                ForEach(viewModel.repositories.indices, id: \.self) { index in
                    let repositoryModel = viewModel.repositories[index]
                    RepositoryRow(repositoryModel: repositoryModel)
                        .onAppear {
                            print("ONAPPEAR \(index)")
                            if index > viewModel.repositories.count - 2 {
                                print("shouldLoad \(index)")
                                viewModel.loadNextPage()
                            }
                        }
                }
            }.padding()
        }
    }
}

#Preview {
    RepositoryListView(userModel: UserSearchModel.mockUser, container: DependencyContainer.createContainerForPreview())
}

fileprivate enum GridColumnType: Int {
    case oneViewInRow = 1
    case twoViewsInRow = 2
    case threeViewsInRow = 3
    
    mutating func changeGridColumnSize() {
        switch self {
        case .oneViewInRow:
            self = .twoViewsInRow
        case .twoViewsInRow:
            self = .threeViewsInRow
        case .threeViewsInRow:
            self = .oneViewInRow
        }
    }
    
    var gridColumImage: Image {
        switch self {
        case .oneViewInRow:
            Image(systemName: "rectangle.grid.1x2")
        case .twoViewsInRow:
            Image(systemName: "rectangle.grid.2x2")
        case .threeViewsInRow:
            Image(systemName: "rectangle.grid.3x2")
        }
    }
}
