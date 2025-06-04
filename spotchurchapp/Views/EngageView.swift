//
//  EngageView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 6/2/25.
//

import SwiftUI

struct EngageView: View {
    @State private var Baptism = BaptismView()
    @ObservedObject var auth: AuthViewModel
    @State private var navigate = false
    let spotBeige = Color(red: 1.0, green: 0.87, blue: 0.67) // Approx #FFE0AA

    var body: some View {
        NavigationView {
            ZStack{
                
                Color(red: 1.0, green: 0.87, blue: 0.67) // Background color
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Image("SpotLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        Text("SPOT Church")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        NavigationLink(destination: destinationView(), isActive: $navigate) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            navigate = true
                        }) {
                            Image(systemName: auth.user != nil ? "person.crop.circle" : "person.crop.circle.fill.badge.plus")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 8)
                    .background(Color.white)
                    .shadow(color: .gray.opacity(0.3), radius: 4, y: 2)
                    .background(spotBeige)

                    
                    
                    // Scrollable Content
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            Image("Events")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipped()
                                .overlay(
                                    Text("EVENTS")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .shadow(radius: 3),
                                    alignment: .center
                                )
                            NavigationLink(destination: BaptismView()) {
                                ZStack {
                                    GeometryReader { geometry in
                                        Image("Baptism")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width, height: geometry.size.height * 1.4)
                                            .clipped()
                                    }
                                    .frame(height: 180)

                                    Text("BAPTISM")
                                        .font(.title)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .shadow(radius: 4)
                                }
                            }
                            .buttonStyle(PlainButtonStyle()) // keeps the image appearance clean

                            Image("calendar")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipped()
                                .overlay(
                                    Text("EVENT CALENDAR")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .shadow(radius: 3),
                                    alignment: .center
                                )
                        }
                    }
                }
                
            }
        }
        }
        
        @ViewBuilder
        private func destinationView() -> some View {
            if auth.user != nil {
                AccountView(auth: auth)
            } else {
                AuthView(auth: auth)
            }
        }
    }

