//
//  HomePageSwiftUIView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 4/11/2025.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        ZStack {
            // Same background
            Image("iPhone 16 Pro - 8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Homepage")
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    // Logo
                    Image("Gemini_Generated_Image_qr0yhoqr0yhoqr0y-removebg-preview")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                // Welcome message
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                        )
                    
                    Text("bonjour mr mohamed amin")
                        .font(.system(size: 20, weight: .medium, design: .serif))
                        .foregroundStyle(.black.opacity(0.85))
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.white.opacity(0.7))
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                // Children list
                VStack(alignment: .leading, spacing: 0) {
                    Text("Ur childs :")
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundStyle(.black.opacity(0.9))
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            // Static child cards
                            ChildCard(name: "Chaima benty", location: "tunis,centre", time: "Just now")
                            ChildCard(name: "Chaima benty", location: "tunis,centre", time: "Just now")
                            ChildCard(name: "Chaima benty", location: "tunis,centre", time: "Just now")
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Child Card Component

struct ChildCard: View {
    let name: String
    let location: String
    let time: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                // Avatar
                Circle()
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.black)
                    
                    Text(location)
                        .font(.system(size: 14))
                        .foregroundStyle(.black.opacity(0.6))
                }
                
                Spacer()
                
                // Heart icon
                Image(systemName: "heart.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.green.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Time
            HStack {
                Spacer()
                Text(time)
                    .font(.system(size: 13))
                    .foregroundStyle(.black.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            
            // Buttons
            HStack(spacing: 12) {
                Button(action: {
                    // Navigate to child profile
                }) {
                    Text("check profile")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                                .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.3), radius: 6, x: 0, y: 3)
                        )
                }
                
                Button(action: {
                    // Open map
                }) {
                    Text("check in map")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                                .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.3), radius: 6, x: 0, y: 3)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white.opacity(0.8))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

#Preview {
    HomePage()
}
