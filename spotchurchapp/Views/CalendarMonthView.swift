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

    // MARK: - Weekday symbols (Fri, Sat, Sun)
    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let allDays = formatter.shortWeekdaySymbols else { return ["Fri", "Sat", "Sun"] }
        return [allDays[5], allDays[6], allDays[0]] // ["Fri", "Sat", "Sun"]
    }

    // MARK: - Dates in current month for Fri/Sat/Sun
    private var weekendDatesInMonth: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: currentDate),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))
        else { return [] }

        return range.compactMap { day in
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                let weekday = calendar.component(.weekday, from: date)
                return (weekday == 6 || weekday == 7 || weekday == 1) ? date : nil
            }
            return nil
        }
    }

    // MARK: - Group dates by weekday (6 = Fri, 7 = Sat, 1 = Sun)
    private var groupedWeekendDates: [Int: [Date]] {
        Dictionary(grouping: weekendDatesInMonth) {
            calendar.component(.weekday, from: $0)
        }
    }

    // MARK: - Helper: Convert weekday number to name
    private func weekdayName(for weekday: Int) -> String {
        switch weekday {
        case 6: return "Friday"
        case 7: return "Saturday"
        case 1: return "Sunday"
        default: return ""
        }
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            // ✅ Month label
            Text(currentMonthYear)
                .font(.title3)
                .fontWeight(.medium)

            // ✅ Legend
            HStack(spacing: 4) {
                Circle().fill(Color.blue).frame(width: 10, height: 10)
                Text("Virtual (Fridays)")
            }
            HStack(spacing: 4) {
                Circle().fill(Color.green).frame(width: 10, height: 10)
                Text("In-person (Sat & Sun)")
            }
                Spacer()
            
            .font(.caption)
            .padding(.horizontal)

            // ✅ Day groupings
            VStack(alignment: .leading, spacing: 16) {
                ForEach([6, 7, 1], id: \.self) { weekday in
                    if let dates = groupedWeekendDates[weekday] {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(weekdayName(for: weekday))
                                .font(.headline)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(dates, id: \.self) { date in
                                        let weekday = calendar.component(.weekday, from: date)
                                        let bgColor: Color = (weekday == 6) ? Color.blue : Color.green
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
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

struct CalendarMonthView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMonthView(selectedDate: .constant(nil))
    }
}
