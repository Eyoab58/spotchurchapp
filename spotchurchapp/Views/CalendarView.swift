//
//  CalendarView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 5/10/25.
//

import SwiftUI

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var color: Color = .blue
    @State private var calendarEvents: [CalendarEvent] = []

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
        return formatter.veryShortWeekdaySymbols
    }

    var body: some View {
        let firstWeekday = calendar.component(.weekday, from: daysInMonth.first ?? Date()) - 1

        ZStack {
            Image("chatGPT")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    // Color and Month Picker
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calendar Color")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        ColorPicker("", selection: $color, supportsOpacity: false)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Month")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                            .labelsHidden()
                    }

                    // Weekday Labels
                    HStack {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)


                    // Calendar Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                        ForEach(0..<firstWeekday, id: \.self) { _ in Text("") }

                        ForEach(daysInMonth, id: \.self) { date in
                            let day = calendar.component(.day, from: date)

                            VStack(spacing: 4) {
                                Text("\(day)")
                                    .frame(maxWidth: .infinity)
                                    .padding(8)
                                    .background(calendar.isDate(date, inSameDayAs: selectedDate) ? color : Color.clear)
                                    .foregroundColor(calendar.isDate(date, inSameDayAs: selectedDate) ? .white : .primary)
                                    .clipShape(Circle())

                                if hasEvent(on: date) {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 6, height: 6)
                                }
                            }
                            .onTapGesture {
                                selectedDate = date
                            }
                            .accessibilityLabel(Text("Day \(day)"))
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxHeight: 320) // Adjust based on device

                    // Event list
                    EventListView(selectedDate: selectedDate, events: calendarEvents)
                        .padding(.top)
                }
                .padding(.horizontal)
                .padding(.top)
            }

        }
        .scaledToFill()
        .onAppear {
                fetchRemoteEvents { events in
                    print("✅ Received \(events.count) events")
                    for event in events {
                        print("📅 \(event.title) on \(event.date)")
                    }
                    self.calendarEvents = events
                }
            }

    }

    
    func fetchRemoteEvents(completion: @escaping ([CalendarEvent]) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let events: [CalendarEvent] = [
            CalendarEvent(title: "SPOT Young Adults Game Night",
                          date: formatter.date(from: "2025-05-23")!,
                          url: "https://www.spotchurch.org/events/spot-young-adults-game-night"),
            CalendarEvent(title: "College Bible Study",
                          date: formatter.date(from: "2025-05-30")!,
                          url: "https://www.spotchurch.org/events/college-bible-study"),
            CalendarEvent(title: "Shepherds Table Volunteer Sign-Up",
                          date: formatter.date(from: "2025-05-31")!,
                          url: "https://www.spotchurch.org/events/shepherds-table-volunteer-sign-up")
        ]

        DispatchQueue.main.async {
            completion(events)
        }
    }




    
    private func hasEvent(on date: Date) -> Bool {
        calendarEvents.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }
}
