//
//  AccountView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 3/29/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AccountView: View {
    @ObservedObject var auth: AuthViewModel
    @Environment(\.presentationMode) var presentationMode  // ✅ Dismiss helper

    @State private var fullName: String = ""
    @State private var dateJoined: String = ""
    @State private var isLoading = true
    @State private var isUserLoggedIn = Auth.auth().currentUser != nil

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if isUserLoggedIn {
                    if isLoading {
                        ProgressView("Loading account info...")
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)

                        Text(fullName)
                            .font(.title)
                            .bold()

                        Text("Member since \(dateJoined)")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Spacer()

                        // ✅ Logout button
                        Button(action: {
                            auth.logout()
                            presentationMode.wrappedValue.dismiss() // ✅ Return to Home
                        }) {
                            Text("Log Out")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    Text("You must be logged in to view your account.")
                }
            }
            .padding()
            .onAppear { loadUserInfo() }
            .navigationTitle("My Account")
        }
    }

    func loadUserInfo() {
        guard let user = Auth.auth().currentUser else {
            isUserLoggedIn = false
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let firstName = data?["firstName"] as? String ?? ""
                let lastName = data?["lastName"] as? String ?? ""
                fullName = "\(firstName) \(lastName)"

                if let timestamp = data?["createdAt"] as? Timestamp {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    dateJoined = formatter.string(from: timestamp.dateValue())
                }
            } else {
                fullName = "Unknown User"
                dateJoined = "Unavailable"
            }

            isLoading = false
        }
    }
}


struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(auth: AuthViewModel())
    }
}

