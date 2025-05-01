//
//  TimeSlotPicker.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 4/1/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TimeSlotPicker: View {
    @Binding var selectedTime: String?
    let disabledSlots: [String]

    private let slots = [
        "4:00 PM", "4:30 PM", "5:00 PM", "5:30 PM", "6:00 PM", "6:30 PM",
        "7:00 PM", "7:30 PM", "8:00 PM", "8:30 PM", "9:00 PM", "9:30 PM",
        "10:00 PM", "10:30 PM"
    ]

    var body: some View {
        VStack {
            Text("Select a Time Slot")
                .font(.title2)
                .padding()

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(slots, id: \.self) { slot in
                        Button(action: {
                            selectedTime = slot
                        }) {
                            Text(slot)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(disabledSlots.contains(slot) ? Color.gray.opacity(0.5) : (selectedTime == slot ? Color.blue : Color.gray.opacity(0.2)))
                                .foregroundColor(disabledSlots.contains(slot) ? .white.opacity(0.5) : (selectedTime == slot ? .white : .black))
                                .cornerRadius(8)
                        }
                        .disabled(disabledSlots.contains(slot))
                    }
                }
                .padding()
            }
        }
    }
}

struct TimeSlotPicker_Previews: PreviewProvider {
    static var previews: some View {
        TimeSlotPicker(selectedTime: .constant(nil), disabledSlots: ["5:00 PM", "7:30 PM"])
    }
}


