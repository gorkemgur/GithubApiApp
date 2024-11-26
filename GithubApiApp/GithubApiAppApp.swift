//
//  GithubApiAppApp.swift
//  GithubApiApp
//
//  Created by Görkem Gür on 24.11.2024.
//

import SwiftUI

@main
struct GithubApiAppApp: App {
    private let container: DependencyContainer
    
    init() {
        self.container = DependencyContainer()
    }
    var body: some Scene {
        WindowGroup {
            UserSearchListView(container: container)
        }
    }
}
