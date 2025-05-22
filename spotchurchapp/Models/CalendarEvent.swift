//
//  CalendarEvent.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 5/17/25.
//
import SwiftUI

struct CalendarEvent: Identifiable, Decodable {
    var id = UUID()
    let title: String
    let date: Date
    let url: String?  // Optional
}


