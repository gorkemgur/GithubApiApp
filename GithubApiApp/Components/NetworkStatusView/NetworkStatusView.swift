//
//  NetworkStatusView.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import SwiftUI

struct NetworkStatusView: View {
    @State var hasNetworkConnection: Bool
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(hasNetworkConnection ? "You Are Online" : "You Are Offline")
                .font(.body)
                .foregroundStyle(Color.white)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(hasNetworkConnection ? Color.green : Color.red)
                }
        }.animation(.easeInOut)
    }
}

#Preview {
    NetworkStatusView(hasNetworkConnection: true)
}
