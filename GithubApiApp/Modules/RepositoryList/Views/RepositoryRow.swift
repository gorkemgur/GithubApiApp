//
//  RepositoryRow.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import SwiftUI

struct RepositoryRow: View {
    private let repositoryModel: RepositoryModel
    private var gridColumnType: GridColumnType
    
    init(repositoryModel: RepositoryModel, gridColumnType: GridColumnType) {
        self.repositoryModel = repositoryModel
        self.gridColumnType = gridColumnType
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                contentView
            }
            Spacer()
        }.ignoresSafeArea(.keyboard)
            .frame(maxWidth: .infinity)
    }
    
    private var contentView: some View {
        VStack(alignment: .leading) {
            switch gridColumnType {
            case .oneViewInRow:
                oneViewInRow
            case .twoViewsInRow:
                twoViewsInRow
            case .threeViewsInRow:
                threeViewsInRow
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
        }.padding(10)
    }
    
    private var oneViewInRow: some View {
        HStack(alignment: .top) {
            userImageView
            VStack(alignment: .leading, spacing: 10) {
                repositoryStatView(title: "Repository Name", description: repositoryModel.repositoryName)
                repositoryStatView(title: "Repository Description", description: repositoryModel.repositoryDescription)
                repositoryUrlView
            }
            Spacer()
            repositoryOwnerView
        }
    }
    
    private var twoViewsInRow: some View {
        VStack(alignment: .leading, spacing: 10) {
            repositoryStatView(title: "Repository Name", description: repositoryModel.repositoryName)
            repositoryStatView(title: "Repository Description", description: repositoryModel.repositoryDescription)
            repositoryUrlView
        }
    }
    
    private var threeViewsInRow: some View {
        VStack(alignment: .leading) {
            Text(repositoryModel.repositoryName)
                .font(.system(size: 14)).bold()
                .lineLimit(2)
           showRepositoryInWebButton
        }
    }
    
    private var repositoryOwnerView: some View {
        HStack {
            Text(repositoryModel.isForked ? "Forked" : "Owner")
                .font(.system(size: 14)).bold()
                .lineLimit(2)
            Circle()
                .foregroundStyle(repositoryModel.isForked ? .red : .green)
                .frame(width: 12, height: 12)
        }
    }
    
    private var repositoryUrlView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Repository URL")
                .font(.system(size: 14)).bold()
            HStack {
                showRepositoryInWebButton
                Spacer()
            }
        }
    }
    
    private var showRepositoryInWebButton: some View {
        Button(action: {
            if let repositoryURL = URL(string: repositoryModel.repositoryURL),
               UIApplication.shared.canOpenURL(repositoryURL) {
                UIApplication.shared.open(repositoryURL)
            }
        }, label: {
            HStack {
                Image(systemName: "safari.fill")
                    .frame(width: 10, height: 10)
                Text(gridColumnType != .threeViewsInRow ? "Show Repository In Safari" : "Open Safari")
                    .font(.system(size: 12))
            }.padding(.horizontal, 2)
        })
    }
    
    @ViewBuilder
    private func repositoryStatView(title: String, description: String?) -> some View {
        if let description = description, !description.isEmpty {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 14)).bold()
                Text(description)
                    .lineLimit(2)
                    .font(.system(size: 12))
            }
        }
    }
    
    private var userImageView: some View {
        AsyncImage(url: URL(string: repositoryModel.owner?.avatarURL ?? ""), content: { userImage in
            userImage
                .resizable()
                .aspectRatio(contentMode: .fit)
        }, placeholder: {
            Image(systemName: "person")
                .padding()
                .background(Color.clear)
        })
        .frame(width: 30, height: 30)
        .clipShape(.circle)
    }
}

#Preview {
    RepositoryRow(repositoryModel: RepositoryModel.mockData, gridColumnType: .oneViewInRow)
}
