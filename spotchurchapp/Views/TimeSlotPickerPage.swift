//
//  TimeSlotPickerPage.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 4/2/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct TimeSlotPickerPage: View {
    @ObservedObject var appointmentVM: AppointmentViewModel
    @State private var showConfirmation = false
    let selectedDate: Date
    @Binding var isShowing: Bool
    @State private var selectedTime: String?  // Selection state
    
    var body: some View {
        VStack {
            
            Text("Available times on \(formatted(selectedDate))")
                .font(.title2)
                .padding(.bottom)
            
            // Integrate TimeSlotSelector here
            TimeSlotPicker(
                selectedTime: $selectedTime,
                disabledSlots: appointmentVM.bookedSlotsArray
            )
            
            if let time = selectedTime {
                Button("Confirm Appointment at \(time)") {
                    confirmAppointment(date: selectedDate, time: time)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            appointmentVM.fetchAppointments(for: selectedDate)
        }
        .alert(isPresented: $showConfirmation) {  // 👈 Add here
            Alert(
                title: Text("Appointment Confirmed"),
                message: Text("Your appointment has been booked."),
                dismissButton: .default(Text("OK")) {
                    isShowing = false
                }
            )
        }
    }
    // Date formatter
    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func fetchUserName(userID: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let fullName = data?["fullName"] as? String
                completion(fullName)
            } else {
                print("User profile not found")
                completion(nil)
            }
        }
    }
    
    private func confirmAppointment(date: Date, time: String) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        // 🔍 Check if the time slot is still available in Firestore
        appointmentVM.isTimeSlotAvailable(date: date, time: time) { isAvailable in
            if isAvailable {
                // Proceed with booking the appointment using only userID
                appointmentVM.reserveAppointment(
                    date: date,
                    time: time,
                    userID: userID 
                ) { error in
                    if let error = error {
                        print("Error saving appointment: \(error.localizedDescription)")
                    } else {
                        print("✅ Appointment confirmed successfully!")
                        appointmentVM.fetchAppointments(for: date)  // Refresh booked slots
                        selectedTime = nil  // Clear selection
                        showConfirmation = true  // Trigger confirmation alert
                    }
                }
            } else {
                // Slot already taken
                print("❌ Time slot already booked by someone else.")
            }
        }
    }
}
