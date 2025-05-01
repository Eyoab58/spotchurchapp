//
//  ContentView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 3/17/25.
//
import SwiftUI

struct ContentView: View {
    @State private var isVideoFinished = false

    var body: some View {
//        if isVideoFinished {
            // 🔥 Show TabView only after video finishes
            TabView {
                HomeView(auth: AuthViewModel())
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                ConfessionView(day: Date(), isSelected: .constant(false))
                    .tabItem {
                        Image(systemName: "doc.fill")
                        Text("Confession")
                    }

                ResourcesView()
                    .tabItem {
                        Image(systemName: "book")
                        Text("Resources")
                    }
            }
//        } else {
//            LaunchVideoView(isVideoFinished: $isVideoFinished)
//        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
