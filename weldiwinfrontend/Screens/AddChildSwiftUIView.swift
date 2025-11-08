//
//  AddChildSwiftUIView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 5/11/2025.
//

import SwiftUI

enum DeviceType: String, Codable, CaseIterable {
    case PHONE = "PHONE"
    case WATCH = "WATCH"
}

struct CreateChildRequest: Codable {
    let firstName: String
    let lastName: String
    let deviceType: DeviceType?
    let deviceId: String?
}

struct AddChildView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var deviceType: DeviceType = .PHONE
    @State private var deviceId = ""
    @State private var isLoading = false
    @State private var alertText: String?
    @State private var showAlert = false
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Same background
                Image("iPhone 16 Pro - 8")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Back button
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(.black.opacity(0.85))
                                    .frame(width: 44, height: 44)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Header
                        VStack(spacing: 8) {
                            Text("Add Child")
                                .font(.system(size: 40, weight: .bold, design: .serif))
                                .foregroundStyle(.black.opacity(0.85))
                                .padding(.top, 20)
                            
                            Text("Add a new child to your account")
                                .font(.system(size: 16))
                                .foregroundStyle(.black.opacity(0.6))
                        }
                        .padding(.bottom, 30)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            // First Name Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("First Name :")
                                    .font(.system(size: 20, weight: .semibold, design: .serif))
                                    .foregroundStyle(.black.opacity(0.85))
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .stroke(.black.opacity(0.25), lineWidth: 1.5)
                                        .fill(Color.white.opacity(0.75))
                                        .frame(height: 56)
                                    
                                    TextField("", text: $firstName)
                                        .font(.system(size: 15))
                                        .foregroundStyle(.black.opacity(0.85))
                                        .padding(.horizontal, 18)
                                }
                            }
                            .padding(.horizontal, 28)
                            .padding(.bottom, 20)
                            
                            // Last Name Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Last Name :")
                                    .font(.system(size: 20, weight: .semibold, design: .serif))
                                    .foregroundStyle(.black.opacity(0.85))
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .stroke(.black.opacity(0.25), lineWidth: 1.5)
                                        .fill(Color.white.opacity(0.75))
                                        .frame(height: 56)
                                    
                                    TextField("", text: $lastName)
                                        .font(.system(size: 15))
                                        .foregroundStyle(.black.opacity(0.85))
                                        .padding(.horizontal, 18)
                                }
                            }
                            .padding(.horizontal, 28)
                            .padding(.bottom, 20)
                            
                            // Device Type
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Device Type :")
                                    .font(.system(size: 20, weight: .semibold, design: .serif))
                                    .foregroundStyle(.black.opacity(0.85))
                                
                                Picker("Device Type", selection: $deviceType) {
                                    ForEach(DeviceType.allCases, id: \.self) { type in
                                        Text(type.rawValue.capitalized).tag(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal, 4)
                            }
                            .padding(.horizontal, 28)
                            .padding(.bottom, 20)
                            
                            // Device ID (optional)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Device ID (optional) :")
                                    .font(.system(size: 20, weight: .semibold, design: .serif))
                                    .foregroundStyle(.black.opacity(0.85))
                                
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                                        .stroke(.black.opacity(0.25), lineWidth: 1.5)
                                        .fill(Color.white.opacity(0.75))
                                        .frame(height: 56)
                                    
                                    TextField("", text: $deviceId)
                                        .font(.system(size: 15))
                                        .foregroundStyle(.black.opacity(0.85))
                                        .padding(.horizontal, 18)
                                }
                            }
                            .padding(.horizontal, 28)
                            .padding(.bottom, 40)
                            
                            // Add Child Button
                            Button(action: addChild) {
                                HStack(spacing: 8) {
                                    if isLoading {
                                        ProgressView()
                                            .tint(.white)
                                            .scaleEffect(0.85)
                                    }
                                    Text(isLoading ? "Adding..." : "Add Child")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .foregroundStyle(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.98, green: 0.65, blue: 0.45),
                                                    Color(red: 0.95, green: 0.55, blue: 0.35)
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4), radius: 12, x: 0, y: 6)
                                )
                            }
                            .disabled(isLoading)
                            .padding(.horizontal, 28)
                            .padding(.bottom, 40)
                            
                            // Hidden NavigationLink to Home
                            NavigationLink(destination: HomePage(), isActive: $navigateToHome) {
                                EmptyView()
                            }
                            .hidden()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("Add Child", isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    if alertText?.contains("successfully") == true {
                        navigateToHome = true
                    }
                }
            } message: {
                Text(alertText ?? "")
            }
        }
    }
    
    // MARK: - Actions
    
    private func addChild() {
        if let message = validate() {
            alertText = message
            showAlert = true
            return
        }
        
        isLoading = true
        
        guard let token = KeychainHelper.shared.get(forKey: "access_token") else {
            alertText = "Please sign in"
            showAlert = true
            isLoading = false
            return
        }
        
        let createRequest = CreateChildRequest(
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces),
            deviceType: deviceType,
            deviceId: deviceId.isEmpty ? nil : deviceId.trimmingCharacters(in: .whitespaces)
        )
        
        NetworkService.shared.postRequestWithAuth(to: .createChild, body: createRequest, token: token) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    self.alertText = "Child added successfully! ✅"
                    self.showAlert = true
                case .failure(let error):
                    self.alertText = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
    
    private func validate() -> String? {
        if firstName.isEmpty { return "First name is required." }
        if lastName.isEmpty { return "Last name is required." }
        return nil
    }
}

#Preview {
    AddChildView()
}
