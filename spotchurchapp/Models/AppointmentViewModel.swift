//
//  AppointmentViewModel.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 4/24/25.
//

import Foundation
import FirebaseFirestore

class AppointmentViewModel: ObservableObject {
    @Published var appointments: [String: String] = [:] // time -> userID
    
    private var db = Firestore.firestore()
    
    // Computed property for booked slots (time keys)
    var bookedSlotsArray: [String] {
        return Array(appointments.keys)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Match how you store dates in Firestore
        return formatter
    }()

    
    
    
    // Fetch appointments and listen for updates
    func fetchAppointments(for date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)

        db.collection("confessionAppointments")
            .whereField("date", isEqualTo: dateString)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    // 🎯 Print Firestore error here!
                    print("Firestore fetchAppointments error: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No documents for this date")
                    return
                }

                var updatedAppointments: [String: String] = [:]
                for doc in documents {
                    let data = doc.data()
                    if let time = data["time"] as? String,
                       let userID = data["userID"] as? String {
                        updatedAppointments[time] = userID
                    }
                }
                DispatchQueue.main.async {
                    self.appointments = updatedAppointments
                }
            }
    }


    func reserveAppointment(date: Date, time: String, userID: String, completion: @escaping (Error?) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let dateString = formatter.string(from: date)
        
        let sanitizedTime = time.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: ":", with: "-")
        let documentID = "\(dateString)_\(sanitizedTime)"
        
        let appointmentRef = db.collection("confessionAppointments").document(documentID)
        
        //  Step 1: Fetch user's first and last name
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data(),
                  let firstName = data["firstName"] as? String,
                  let lastName = data["lastName"] as? String else {
                print("User profile missing required fields.")
                completion(NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey: "User profile missing required fields."]))
                return
            }
            
            //  Step 2: Proceed to check if the appointment exists
            appointmentRef.getDocument { document, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                if let document = document, document.exists {
                    completion(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "This time slot is already reserved."]))
                } else {
                    //  Step 3: Save the appointment with first and last name
                    appointmentRef.setData([
                        "date": dateString,
                        "time": time,
                        "userID": userID,
                        "firstName": firstName,
                        "lastName": lastName, 
                        "reservedAt": Timestamp()
                    ]) { error in
                        completion(error)
                    }
                }
            }
        }
    }

    
    func isTimeSlotAvailable(date: Date, time: String, completion: @escaping (Bool) -> Void) {
        let dateString = dateFormatter.string(from: date)
        
        db.collection("confessionAppointments")
            .whereField("date", isEqualTo: dateString)
            .whereField("time", isEqualTo: time)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error checking time slot availability: \(error.localizedDescription)")
                    completion(false) // Assume unavailable on error
                    return
                }
                // If no documents found, the slot is available
                completion(snapshot?.documents.isEmpty == true)
            }
    }
}
