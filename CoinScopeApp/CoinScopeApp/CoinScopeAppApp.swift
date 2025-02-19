//
//  CoinScopeAppApp.swift
//  CoinScopeApp
//
//  Created by Berke Yılmaz on 12.02.2025.
//

import SwiftUI

@main
struct CoinScopeAppApp: App {
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
