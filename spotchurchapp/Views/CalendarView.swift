//
//  CalendarView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 5/10/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var color: Color = .blue
    
    private let calendar = Calendar.current

    private var daysInMonth: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: selectedDate) else { return [] }
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }

    private var daysOfWeek: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter.veryShortWeekdaySymbols // ["S", "M", "T", "W", "T", "F", "S"]
    }

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Image("chatGPT")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 4) {
                Text("Calendar Color")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                ColorPicker("", selection: $color, supportsOpacity: false)
            }

            // Date picker
            VStack(alignment: .leading, spacing: 4) {
                Text("Month")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .labelsHidden()
            }

            // Weekday headers
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            // Calendar grid
            let firstWeekday = calendar.component(.weekday, from: daysInMonth.first ?? Date()) - 1
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    // Padding for first row
                    ForEach(0..<firstWeekday, id: \.self) { _ in
                        Text("")
                    }
                    
                    // Day cells
                    ForEach(daysInMonth, id: \.self) { date in
                        let day = calendar.component(.day, from: date)
                        Text("\(day)")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(calendar.isDate(date, inSameDayAs: selectedDate) ? color : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedDate = date
                            }
                    }
                }
            }
        }
        .padding()
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
 
