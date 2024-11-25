//
//  UserSearchListView.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import SwiftUI

struct UserSearchListView: View {
    @StateObject private var viewModel: UserSearchListViewModel
    @State var showNetworkStatus = false
    @State private var isPresented = false
    
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
        _viewModel = StateObject(
            wrappedValue: UserSearchListViewModel(
                networkService: container.networkService,
                storageService: container.localStorageService,
                networkMonitoringService: container.networkMonitoringService))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                contentView
                    .searchable(text: $viewModel.userSearchQueryText, prompt: "Search User")
                
                switch viewModel.viewState {
                case .showLoading:
                    loadingView
                case .showEmptyView:
                    emptyView
                case .hideLoading, .idle:
                    Color.clear
                }
                
                if showNetworkStatus {
                    NetworkStatusView(hasNetworkConnection: viewModel.isNetworkConnectionAvailable)
                }
            }
            .navigationTitle("User Search")
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear {
            showNetworkStatus = !viewModel.isNetworkConnectionAvailable
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    showNetworkStatus = !showNetworkStatus
                }
            }
        }
        .onChange(of: viewModel.isNetworkConnectionAvailable) { _ in
            showNetworkStatus = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    showNetworkStatus = false
                }
            }
        }.sheet(isPresented: $isPresented) {
            if let userModel = viewModel.userModel {
                RepositoryListView(
                    userModel: userModel,
                    container: container
                )
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if let user = viewModel.userModel {
            UserRow(user: user)
                .onTapGesture {
                    isPresented = true
                }
        } else {
            emptyView
        }
    }
    
    private var emptyView: some View {
        VStack {
            Text("There is no user data")
                .font(.system(.title2))
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
    
}

#Preview {
    UserSearchListView(
        container: DependencyContainer.createContainerForPreview())
    
}
