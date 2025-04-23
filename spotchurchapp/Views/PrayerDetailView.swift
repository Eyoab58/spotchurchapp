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
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
                .padding()
        }
        .navigationTitle("Prayer")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
    }
}


struct PrayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerDetailView(text: "This is a preview of a prayer.")
    }
}
