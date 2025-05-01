//
//  AuthViewModel.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 3/27/25.
//

import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: User?

    private let db = Firestore.firestore()

    init() {
        self.user = Auth.auth().currentUser
    }

    func register(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result?.user, error == nil {
                let uid = user.uid
                let displayName = "\(firstName) \(lastName)"  // 🔥 Full name

                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { commitError in
                    if let commitError = commitError {
                        DispatchQueue.main.async {
                            completion(commitError)
                        }
                        return
                    }

                    // Save to Firestore
                    let userData: [String: Any] = [
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email,
                        "createdAt": Timestamp()
                    ]

                    self.db.collection("users").document(uid).setData(userData) { firestoreError in
                        DispatchQueue.main.async {
                            self.user = user
                            completion(firestoreError)
                        }
                    }
                }

            } else {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.user = result?.user
                completion(error)
            }
        }
    }

    func logout() {
        try? Auth.auth().signOut()
        self.user = nil
    }
}
