//
//  TimeSlotPicker.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 4/1/25.
//

import SwiftUI

struct TimeSlotPicker: View {
    @Binding var selectedTime: String?

    let slots = [
        "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM",
        "12:00 PM", "12:30 PM", "1:00 PM", "1:30 PM",
        "2:00 PM", "2:30 PM", "3:00 PM", "3:30 PM",
        "4:00 PM", "4:30 PM", "5:00 PM", "5:30 PM"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(slots, id: \.self) { slot in
                    Text(slot)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedTime == slot ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(selectedTime == slot ? .white : .black)
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedTime = slot
                        }
                }
            }
            .padding(.vertical)
        }
    }
}

struct TimeSlotPicker_Previews: PreviewProvider {
    static var previews: some View {
        TimeSlotPicker(selectedTime: .constant(nil))
    }
}



