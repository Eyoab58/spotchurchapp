//
//  PrayerDetailView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 4/21/25.
//

import SwiftUI

struct PrayerDetailView: View {
    let text: String

    var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                // Background Image
                Image("chatGPT")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(text)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5)) // Optional: improves readability
                        .cornerRadius(10)
                        .padding()
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Prayer")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct PrayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerDetailView(text: "This is a preview of a prayer.")
    }
}
