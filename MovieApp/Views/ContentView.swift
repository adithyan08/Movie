//
//  ContentView.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//
import SwiftUI
struct ContentView: View {
    @EnvironmentObject var router: AppRouter
       @State private var selectedTab = 0
    var body: some View {
        TabView {
            MovieListView()
                .tabItem {
                    Image(systemName: "film")
                    Text("Movies")
                }
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
        }
        
        .accentColor(.red)
    }
}
// MARK: - Preview Providers
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LocalStorageService.shared)
    }
}
