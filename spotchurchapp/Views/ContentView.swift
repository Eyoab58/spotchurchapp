//
//  ContentView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 3/17/25.
//

import SwiftUI




struct ContentView: View {
    
    var body: some View {
        TabView{
            HomeView(auth: AuthViewModel())
                .tabItem() {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            
            ConfessionView(day: Date(), isSelected: .constant(false))
                .tabItem() {
                    Image(systemName: "doc.fill")
                    Text("Confession")
                }
            
            
            ResourcesView()
                .tabItem() {
                    Image(systemName: "book")
                    Text("Resources")
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
