//
//  BaptismView.swift
//  spotchurchapp
//
//  Created by Eyoab Asrat on 6/2/25.
//

import SwiftUI

struct BaptismView: View {
    var body: some View {
        ZStack {
            Image("chatGPT")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // Title
                    Text("Baptism")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 24)
                        .padding(.horizontal)
                        .padding(.leading, 45)
                    
                    // Scripture Quote
                    Text("""
                    \"Go therefore and make disciples of all nations, baptizing them in the name of the Father and of the Son and of the Holy Spirit, teaching them to observe all things that I have commanded you; and lo, I am with you always even to the end of the age.\" ~ Matthew 28: 19-20
                    """)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(red: 255/255, green: 250/255, blue: 240/255)) // soft cream tone
                    .cornerRadius(16)
                    .shadow(radius: 2)
                    .padding(.horizontal, 24)
                    .padding()
                    .padding(.horizontal)
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
                    
                    // Baptismal Journey Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("The Baptismal Journey")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .fontWeight(.bold)
                            .padding(.bottom, 4)
                            .padding(.leading, 29)
                        
                        Text("We celebrate the sacred act of baptism as a significant milestone in one's spiritual life. At our church, we embrace the diversity of our congregation by offering two distinct baptismal paths: one for infants and another for adults.")
                            .font(.system(size: 18, design: .serif))
                            .padding(.leading, 29)
                            .padding(.trailing, 29)
                        
                        
                        Text("Both forms of baptism hold deep significance in our faith journey, and we believe that regardless of age, baptism is a sacred step towards a deeper relationship with God and His community. Whether you are considering baptism for yourself or your child, we invite you to explore this sacred sacrament further and discover the beauty of God's grace at work in your life.")
                            .font(.system(size: 18, design: .serif))
                            .padding(.leading, 29)
                            .padding(.trailing, 29)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(16)
                    .shadow(radius: 3)
                    .padding(.horizontal, 16)
                    
                    // Adult Baptism Card
                    baptismCard(
                        imageName: "AdultBaptism",
                        text: "Adult baptism is a powerful and transformative experience. It signifies a new beginning, a spiritual rebirth, and a conscious decision to follow Christ in obedience and discipleship.",
                        urlString: "http://spotc.easytitheplus.com/external/form/fa569a85-6949-4f7f-969a-820289f1db33"
                    )
                    
                    // Infant Baptism Card
                    baptismCard(
                        imageName: "InfantBaptism",
                        text: "As a symbol of God's grace and the commitment of parents and the congregation, infant baptism is a cherished tradition within our community. It is a joyous occasion where families come together to dedicate their little ones to the love and guidance of God, surrounded by the support and prayers of their church family.",
                        urlString: "https://spotc.easytitheplus.com/external/form/94e96b8d-0e9c-4d41-8f7c-b27f7df23786"
                    )
                    
                    Spacer(minLength: 40)
                }
                .padding(.bottom, 16)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Reusable Baptism Card View
    @ViewBuilder
    func baptismCard(imageName: String, text: String, urlString: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipped()
                    .cornerRadius(8)
                    .padding(.leading, 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(text)
                        .font(.system(size: 18, design: .serif))
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 30)
                    
                }
                .padding(.trailing, 4)
            }
            
            Button(action: {
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Sign Up")
                    .fontWeight(.semibold)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 24)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .background(Color.white.opacity(0.95))
        .cornerRadius(16)
        .shadow(radius: 3)
        .padding(.horizontal, 16)
    }
}

struct BaptismView_Previews: PreviewProvider {
    static var previews: some View {
        BaptismView()
    }
}
