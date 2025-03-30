//
//  ResourcesView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 3/17/25.
//

import SwiftUI
import FirebaseAuth

struct ConfessionView: View {
    @State private var isUserLoggedIn = Auth.auth().currentUser != nil

    var body: some View {
        VStack {
            if isUserLoggedIn {
                // User is logged in — show your main content
                Text("Welcome to the Confession section!")
                    .font(.title)
                    .padding()
            } else {
                // User not logged in — show prompt
                VStack(spacing: 16) {
                    Text("You must be logged in to access this section.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()

                    NavigationLink(destination: AuthView()) {
                        Text("Log In or Create Account")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            // Keep checking on view appear in case they log in elsewhere
            isUserLoggedIn = Auth.auth().currentUser != nil
        }
    }
}

struct ConfessionView_Previews: PreviewProvider {
    static var previews: some View {
        ConfessionView()
    }
}
