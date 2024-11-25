//
//  RepositoryRow.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import SwiftUI

struct RepositoryRow: View {
    private let repositoryModel: RepositoryModel
    
    init(repositoryModel: RepositoryModel) {
        self.repositoryModel = repositoryModel
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
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
        }.padding(10)
    }
    
    private var repositoryOwnerView: some View {
        HStack {
            Text(repositoryModel.isForked ? "Forked" : "Owner")
                .font(.system(size: 14)).bold()
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
                Button(action: {
                    if let repositoryURL = URL(string: repositoryModel.repositoryURL),
                       UIApplication.shared.canOpenURL(repositoryURL) {
                        UIApplication.shared.open(repositoryURL)
                    }
                }, label: {
                    HStack {
                        Image(systemName: "safari.fill")
                            .frame(width: 10, height: 10)
                        Text("Show Repository In Safari")                
                            .font(.system(size: 12))
                    }.padding(.horizontal, 2)
                })
                Spacer()
            }
        }
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
    RepositoryRow(repositoryModel: RepositoryModel.mockData)
}
