//
//  CalendarMonthView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 4/1/25.
//

import SwiftUI

struct CalendarMonthView: View {
    @Binding var selectedDate: Date?

    private let calendar = Calendar.current
    private let currentDate = Date()

    // MARK: - Title for month + year
    private var currentMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy" // e.g. April 2025
        return formatter.string(from: currentDate)
    }

    // MARK: - Weekday symbols (Sun - Sat)
    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.shortWeekdaySymbols // ["Sun", "Mon", ..., "Sat"]
    }

    // MARK: - Main date grid with nils for blank days
    private var datesInMonth: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)),
              let firstDay = calendar.date(bySetting: .day, value: 1, of: startOfMonth)
        else { return [] }

        let firstWeekday = calendar.component(.weekday, from: firstDay) // 1 = Sunday

        let leadingEmptyDays: [Date?] = Array(repeating: nil, count: firstWeekday - 1)

        let actualDates: [Date?] = range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }

        return leadingEmptyDays + actualDates
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 12) {
            // ✅ Month label
            Text(currentMonthYear)
                .font(.title3)
                .fontWeight(.medium)
                .padding(.bottom, 4)

            // ✅ Legend
            HStack {
                HStack(spacing: 4) {
                    Circle().fill(Color.blue).frame(width: 10, height: 10)
                    Text("Virtual (Weekdays)")
                }
                Spacer()
                HStack(spacing: 4) {
                    Circle().fill(Color.green).frame(width: 10, height: 10)
                    Text("In-person (Sat & Sun)")
                }
            }
            .font(.caption)
            .padding(.horizontal)

            // ✅ Weekday headers
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(weekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
            }

            // ✅ Calendar grid with correct weekday offset
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(datesInMonth.indices, id: \.self) { index in
                    if let date = datesInMonth[index] {
                        let weekday = calendar.component(.weekday, from: date)
                        let isWeekend = weekday == 1 || weekday == 7
                        let bgColor = isWeekend ? Color.green : Color.blue
                        let isSelected = selectedDate == date

                        Text("\(calendar.component(.day, from: date))")
                            .frame(width: 40, height: 40)
                            .background(isSelected ? bgColor : Color.clear)
                            .foregroundColor(isSelected ? .white : .primary)
                            .overlay(
                                Circle().stroke(bgColor, lineWidth: isSelected ? 0 : 2)
                            )
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedDate = date
                            }
                    } else {
                        // Empty cell for offset before the 1st
                        Text("")
                            .frame(width: 40, height: 40)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct CalendarMonthView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMonthView(selectedDate: .constant(nil))
    }
}
