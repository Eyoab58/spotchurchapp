//
//  TimeSlotPickerPage.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 4/2/25.
//

import SwiftUI

struct TimeSlotPickerPage: View {
    let selectedDate: Date
    @Binding var isShowing: Bool
    @State private var selectedTime: String?

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isShowing = false // 👈 Go back
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                    Text("Back")
                }
                .padding()
                Spacer()
            }

            Text("Available times on \(formatted(selectedDate))")
                .font(.title2)
                .padding(.bottom)

            TimeSlotPicker(selectedTime: $selectedTime)

            if let time = selectedTime {
                Button("Confirm Appointment at \(time)") {
                    confirmAppointment(date: selectedDate, time: time)
                    isShowing = false // 👈 Dismiss page
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
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func confirmAppointment(date: Date, time: String) {
        print("📅 Appointment confirmed on \(formatted(date)) at \(time)")
        // TODO: Save to Firestore here
    }
}

struct TimeSlotPickerPage_Previews: PreviewProvider {
    static var previews: some View {
        TimeSlotPickerPage(
            selectedDate: Date(),
            isShowing: .constant(true) // ✅ Correct binding value
        )
    }
}
