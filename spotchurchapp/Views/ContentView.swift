//
//  ContentView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 3/17/25.
//
import SwiftUI

struct ContentView: View {
    @State private var isVideoFinished = false
    @State private var showMainApp = false

    var body: some View {
        ZStack {
            if showMainApp {
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
                    EngageView(auth: AuthViewModel())
                        .tabItem{
                            Image(systemName: "person.2.circle")
                            Text("Engage")
                        }
                    ResourcesView()
                        .tabItem {
                            Image(systemName: "book")
                            Text("Resources")
                        }
                }
                .transition(.opacity)
            }

            if !isVideoFinished {
                LaunchVideoView(isVideoFinished: $isVideoFinished)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 1.0), value: showMainApp)
        .onChange(of: isVideoFinished) { finished in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        showMainApp = true
                    }
                }
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
