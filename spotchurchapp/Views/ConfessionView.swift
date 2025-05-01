//
//  ResourcesView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 3/17/25.
//

import SwiftUI
import FirebaseAuth

struct ConfessionView: View {
    @State private var isUserLoggedIn = Auth.auth().currentUser != nil
    @State private var showAuthView = false
    @StateObject private var auth = AuthViewModel()
    @StateObject private var appointmentVM = AppointmentViewModel()

    let day: Date
    @Binding var isSelected: Bool

    @State private var selectedDate: Date?
    @State private var showTimePickerPage = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0xDE / 255.0, green: 0xC3 / 255.0, blue: 0x8E / 255.0)
                    .ignoresSafeArea()
                
                VStack {
                    if isUserLoggedIn {
                        VStack {
                            Text("Choose a date for your confession")
                                .font(.headline)
                                .padding(.bottom)
                            
                            CalendarMonthView(selectedDate: $selectedDate)
                            
                            Button("Continue") {
                                showTimePickerPage = true
                            }
                            .disabled(selectedDate == nil)
                            .padding()
                            .background(selectedDate != nil ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            NavigationLink(
                                destination: selectedDate.map { date in
                                    TimeSlotPickerPage(
                                        appointmentVM: appointmentVM,
                                        selectedDate: date,              // Date (non-binding ✅)
                                        isShowing: $showTimePickerPage
                                    )
                                },
                                isActive: $showTimePickerPage
                            ) {
                                EmptyView()
                            }
                        }
                        .padding()
                    } else {
                        VStack(spacing: 16) {
                            Text("You must be logged in to access this section.")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Button("Log In or Create Account") {
                                showAuthView = true
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            
                            NavigationLink(
                                destination: AuthView(auth: auth, onLoginSuccess: {
                                    isUserLoggedIn = true
                                    showAuthView = false
                                }),
                                isActive: $showAuthView
                            ) {
                                EmptyView()
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Confession")
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isUserLoggedIn = Auth.auth().currentUser != nil
                }
                if let selectedDate = selectedDate {
                    appointmentVM.fetchAppointments(for: selectedDate)
                }
            }
        }
    }
}
