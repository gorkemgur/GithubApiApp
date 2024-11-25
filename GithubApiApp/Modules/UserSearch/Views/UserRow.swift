//
//  UserRow.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import SwiftUI

struct UserRow: View {
    private let user: UserSearchModel
    
    init(user: UserSearchModel) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                userHeaderView
                userRepositoryStats
            }
            .fixedSize(horizontal: false, vertical: true)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
            }.padding()
            
            Spacer()
        }
    }
    
    private var userHeaderView: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: user.avatarURL), content: { userImage in
                userImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }, placeholder: {
                Image(systemName: "person")
                    .padding()
                    .background(Color.clear)
            })
            .frame(width: 50, height: 50)
            .clipShape(.circle)
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.caption)
                if let userLocation = user.location {
                    Text(userLocation)
                        .font(.caption)
                }
                if let userEmail = user.email {
                    Text(userEmail)
                        .font(.caption)
                }
                Spacer()
            }
        }.padding()
    }
    
    private var userRepositoryStats: some View {
        VStack(spacing: 5) {
            createUserStats(key: "Public Repos", value: "\(user.repositoryCount)")
            createUserStats(key: "Followers", value: "\(user.followersCount)")
            createUserStats(key: "Following", value: "\(user.followingCount)")
            HStack {
                Spacer()
                Text("**Joined At: \(user.accountCreatedAt?.convertDate ?? "")**")
                    .font(.system(.caption))
            }.padding(.top, 10)
            Spacer()
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    private func createUserStats(key: String, value: String?) -> some View {
        if let value = value {
            HStack {
                Text(key)
                    .font(.caption)
                    .padding(.trailing, 15)
                Spacer()
                Text(value)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    UserRow(user: UserSearchModel.mockUser)
}
