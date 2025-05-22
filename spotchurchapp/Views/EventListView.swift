//
//  EventListView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 5/17/25.
//

import SwiftUI

struct EventListView: View {
    var selectedDate: Date
    var events: [CalendarEvent]
    private let calendar = Calendar.current

    var body: some View {
        let dayEvents = events.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }

        if dayEvents.isEmpty {
            Text("No events for this day")
                .foregroundColor(.secondary)
        } else {
            ForEach(dayEvents) { event in
                if let urlString = event.url, let url = URL(string: urlString) {
                    Link(destination: url) {
                        Text(event.title)
                            .foregroundColor(.blue)
                            .underline()
                    }
                } else {
                    Text(event.title)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

