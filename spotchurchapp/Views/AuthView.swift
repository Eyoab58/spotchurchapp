//
//  SwiftUIView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 3/27/25.
//

import SwiftUI

struct AuthView: View {
    @ObservedObject var auth: AuthViewModel
    var onLoginSuccess: (() -> Void)? = nil // 👈 Add this

    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isRegistering = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            if isRegistering {
                TextField("First Name", text: $firstName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button(action: {
                if isRegistering {
                    auth.register(email: email, password: password, firstName: firstName, lastName: lastName) { error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            onLoginSuccess?() // 👈 Notify parent
                        }
                    }
                } else {
                    auth.login(email: email, password: password) { error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            onLoginSuccess?() // 👈 Notify parent
                        }
                    }
                }
            }) {
                Text(isRegistering ? "Register" : "Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Button(action: {
                isRegistering.toggle()
            }) {
                Text(isRegistering ? "Already have an account? Log in" : "Don't have an account? Register")
                    .font(.footnote)
            }
        }
        .padding()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(auth: AuthViewModel())
    }
}
