//
//  DisplayQRCodeView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 6/11/2025.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct DisplayQRCodeView: View {
    @Environment(\.dismiss) var dismiss
    
    let qrCode: String
    let childName: String
    
    @State private var qrImage: UIImage?
    @State private var showCopyConfirmation = false
    
    var body: some View {
        ZStack {
            // Background
            Image("iPhone 16 Pro - 8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Top bar with back button
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.85))
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(.white.opacity(0.2))
                                        .blur(radius: 10)
                                )
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Header Section
                    VStack(spacing: 12) {
                        // QR Code Icon with gradient
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.98, green: 0.65, blue: 0.45),
                                            Color(red: 0.95, green: 0.55, blue: 0.35)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 110, height: 110)
                                .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: "qrcode")
                                .font(.system(size: 50, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                        
                        // Title
                        Text("Child Login QR Code")
                            .font(.system(size: 34, weight: .bold, design: .serif))
                            .foregroundStyle(.black.opacity(0.9))
                        
                        // Subtitle
                        Text("Share this QR code with \(childName)")
                            .font(.system(size: 17))
                            .foregroundStyle(.black.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 35)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // ✅ CENTERED QR Code Display Card
                        HStack {
                            Spacer()
                            
                            VStack(spacing: 20) {
                                ZStack {
                                    // Background card with shadow
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .fill(.white)
                                        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                                .stroke(
                                                    LinearGradient(
                                                        colors: [
                                                            Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.3),
                                                            Color(red: 0.98, green: 0.65, blue: 0.45).opacity(0.3)
                                                        ],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 2
                                                )
                                        )
                                        .frame(width: 300, height: 300)
                                    
                                    // QR Code Image
                                    if let qrImage = qrImage {
                                        Image(uiImage: qrImage)
                                            .interpolation(.none)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 260, height: 260)
                                            .cornerRadius(12)
                                    } else {
                                        VStack(spacing: 12) {
                                            ProgressView()
                                                .tint(Color(red: 0.95, green: 0.55, blue: 0.35))
                                                .scaleEffect(1.2)
                                            Text("Generating QR Code...")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundStyle(.black.opacity(0.6))
                                        }
                                    }
                                }
                                
                                // QR Code Label
                                Text("Scan this code to login")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(.black.opacity(0.6))
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom, 35)
                        
                        // Manual Code Entry Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Or enter code manually")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.black.opacity(0.85))
                                
                                Spacer()
                                
                                Button(action: copyCode) {
                                    HStack(spacing: 6) {
                                        Image(systemName: showCopyConfirmation ? "checkmark.circle.fill" : "doc.on.doc")
                                            .font(.system(size: 16, weight: .medium))
                                        Text(showCopyConfirmation ? "Copied!" : "Copy")
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                    .foregroundStyle(showCopyConfirmation ? Color.green : Color(red: 0.95, green: 0.55, blue: 0.35))
                                }
                            }
                            
                            // Code Display Box
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(.white.opacity(0.9))
                                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                                
                                HStack {
                                    Text(qrCode)
                                        .font(.system(size: 15, weight: .semibold, design: .monospaced))
                                        .foregroundStyle(.black.opacity(0.85))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 18)
                                .padding(.vertical, 16)
                            }
                        }
                        .padding(.bottom, 40)
                        
                        // Instructions Card
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                                
                                Text("How it works")
                                    .font(.system(size: 20, weight: .bold, design: .serif))
                                    .foregroundStyle(.black.opacity(0.9))
                            }
                            
                            VStack(spacing: 16) {
                                InstructionRow(
                                    number: "1",
                                    icon: "qrcode.viewfinder",
                                    text: "Show this QR code to your child"
                                )
                                
                                InstructionRow(
                                    number: "2",
                                    icon: "camera.fill",
                                    text: "Child scans the code with their device"
                                )
                                
                                InstructionRow(
                                    number: "3",
                                    icon: "checkmark.circle.fill",
                                    text: "Child is automatically logged in"
                                )
                            }
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.white.opacity(0.85))
                                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                        )
                        .padding(.bottom, 40)
                        
                        // Done Button
                        Button(action: { dismiss() }) {
                            Text("Done")
                                .font(.system(size: 18, weight: .bold))
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
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4), radius: 12, x: 0, y: 6)
                                )
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 28)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            generateQRCode()
        }
    }
    
    // MARK: - QR Code Generation
    
    private func generateQRCode() {
        DispatchQueue.global(qos: .userInitiated).async {
            let context = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            
            filter.message = Data(qrCode.utf8)
            filter.correctionLevel = "M"
            
            if let outputImage = filter.outputImage {
                let transform = CGAffineTransform(scaleX: 12, y: 12)
                let scaledImage = outputImage.transformed(by: transform)
                
                if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                    let uiImage = UIImage(cgImage: cgImage)
                    DispatchQueue.main.async {
                        self.qrImage = uiImage
                    }
                }
            }
        }
    }
    
    // MARK: - Copy Code
    
    private func copyCode() {
        UIPasteboard.general.string = qrCode
        withAnimation {
            showCopyConfirmation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopyConfirmation = false
            }
        }
    }
}

// MARK: - Enhanced Instruction Row Component

private struct InstructionRow: View {
    let number: String
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Number badge with gradient
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.98, green: 0.65, blue: 0.45),
                                Color(red: 0.95, green: 0.55, blue: 0.35)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                    .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.3), radius: 6, x: 0, y: 3)
                
                Text(number)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            // Icon and text
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color(red: 0.95, green: 0.55, blue: 0.35))
                    .frame(width: 24)
                
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.black.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
}

#Preview {
    DisplayQRCodeView(qrCode: "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6", childName: "John Doe")
}
