//
//  ScanQRCodeView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 6/11/2025.
//

import SwiftUI
import AVFoundation
import AudioToolbox

struct ScanQRCodeView: View {
    @Environment(\.dismiss) var dismiss
    
    var onAuthenticated: () -> Void = {}
    
    @State private var isScanning = false
    @State private var scannedCode: String?
    @State private var manualCode: String = ""
    @State private var isLoading = false
    @State private var alertText: String?
    @State private var showAlert = false
    @State private var showManualEntry = false
    
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
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(.black.opacity(0.4))
                                        .blur(radius: 10)
                                )
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Header Section
                    VStack(spacing: 12) {
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
                                .frame(width: 100, height: 100)
                                .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: "qrcode.viewfinder")
                                .font(.system(size: 45, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 15)
                        
                        Text("Scan QR Code")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                        
                        Text("Point your camera at the QR code")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 30)
                    
                    // Scanner View Card
                    VStack(spacing: 20) {
                        ZStack {
                            QRCodeScannerView(scannedCode: $scannedCode, isScanning: $isScanning)
                                .frame(width: 280, height: 280)
                                .cornerRadius(24)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.95, green: 0.55, blue: 0.35),
                                                    Color(red: 0.98, green: 0.65, blue: 0.45)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 3
                                        )
                                )
                                .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.5), radius: 20, x: 0, y: 10)
                            
                            if isLoading {
                                VStack(spacing: 16) {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(1.5)
                                    Text("Logging in...")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.black.opacity(0.7))
                                .cornerRadius(24)
                            } else if isScanning {
                                VStack {
                                    HStack {
                                        CornerGuide()
                                        Spacer()
                                        CornerGuide()
                                    }
                                    Spacer()
                                    HStack {
                                        CornerGuide()
                                        Spacer()
                                        CornerGuide()
                                    }
                                }
                                .padding(20)
                            }
                        }
                        
                        if isScanning && !isLoading {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                                    .frame(width: 8, height: 8)
                                Text("Ready to scan")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                    }
                    .padding(.bottom, 30)
                    
                    // Divider with "OR"
                    HStack {
                        Rectangle()
                            .fill(.white.opacity(0.3))
                            .frame(height: 1)
                        
                        Text("OR")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 16)
                        
                        Rectangle()
                            .fill(.white.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 30)
                    
                    // Manual Entry Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "keyboard")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("Enter Code Manually")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: pasteCode) {
                                HStack(spacing: 6) {
                                    Image(systemName: "doc.on.clipboard")
                                        .font(.system(size: 14, weight: .medium))
                                    Text("Paste")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.white.opacity(0.2))
                                )
                            }
                        }
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(.white.opacity(0.15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(
                                            showManualEntry ?
                                                LinearGradient(
                                                    colors: [
                                                        Color(red: 0.95, green: 0.55, blue: 0.35),
                                                        Color(red: 0.98, green: 0.65, blue: 0.45)
                                                    ],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ) :
                                                LinearGradient(
                                                    colors: [.white.opacity(0.3)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                ),
                                            lineWidth: showManualEntry ? 2 : 1
                                        )
                                )
                                .frame(height: 56)
                            
                            TextField("Enter QR code here", text: $manualCode)
                                .font(.system(size: 16, weight: .medium, design: .monospaced))
                                .foregroundColor(.white)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .padding(.horizontal, 18)
                                .onTapGesture { showManualEntry = true }
                        }
                        
                        Button(action: loginWithManualCode) {
                            HStack(spacing: 8) {
                                if isLoading {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(0.9)
                                }
                                Text(isLoading ? "Logging in..." : "Login")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .foregroundColor(.white)
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
                        .disabled(isLoading || manualCode.isEmpty)
                        .opacity(manualCode.isEmpty ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 40)
                }
            }
            
        }
        .onChange(of: scannedCode) { _, newValue in
            if let code = newValue, !code.isEmpty {
                handleScannedCode(code)
            }
        }
        .alert("QR Code Login", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                if !isLoading { isScanning = true }
            }
        } message: {
            Text(alertText ?? "")
        }
        .onAppear { isScanning = true }
        .onDisappear { isScanning = false }
    }
    
    // MARK: - Actions
    
    private func handleScannedCode(_ code: String) {
        guard !isLoading else { return }
        loginWithCode(code.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    private func loginWithManualCode() {
        guard !manualCode.isEmpty, !isLoading else { return }
        loginWithCode(manualCode.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    private func loginWithCode(_ code: String) {
        let cleanedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedCode.isEmpty else {
            alertText = "QR code cannot be empty"
            showAlert = true
            isScanning = true
            return
        }
        
        isLoading = true
        isScanning = false
        
        let request = QrLoginRequest(qrCode: cleanedCode)
        
        NetworkService.shared.postRequest(to: .qrLogin, body: request) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(QrLoginResponse.self, from: data)
                        let saved = KeychainHelper.shared.save(token: response.access_token, forKey: "access_token")
                        if saved {
                            onAuthenticated()
                        }
                        else {
                            alertText = "Login succeeded but failed to save session"
                            showAlert = true
                            isScanning = true
                        }
                    } catch {
                        alertText = "Failed to parse response: \(error.localizedDescription)"
                        showAlert = true
                        isScanning = true
                    }
                case .failure(let error):
                    alertText = error.localizedDescription
                    showAlert = true
                    isScanning = true
                }
            }
        }
    }
    
    private func pasteCode() {
        if let clipboard = UIPasteboard.general.string {
            manualCode = clipboard.trimmingCharacters(in: .whitespacesAndNewlines)
            showManualEntry = true
        }
    }
}

// MARK: - Corner Guide Component
private struct CornerGuide: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                .frame(width: 30, height: 3)
            Rectangle()
                .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                .frame(width: 3, height: 30)
        }
    }
}

// MARK: - QR Code Scanner View
struct QRCodeScannerView: UIViewRepresentable {
    @Binding var scannedCode: String?
    @Binding var isScanning: Bool
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let session = AVCaptureSession()
        context.coordinator.session = session
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              session.canAddInput(videoInput) else { return view }
        session.addInput(videoInput)
        
        let metadataOutput = AVCaptureMetadataOutput()
        guard session.canAddOutput(metadataOutput) else { return view }
        session.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        if isScanning { session.startRunning() }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.layer.bounds
        }
        if isScanning { context.coordinator.session?.startRunning() }
        else { context.coordinator.session?.stopRunning() }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(scannedCode: $scannedCode) }
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        @Binding var scannedCode: String?
        var session: AVCaptureSession?
        
        init(scannedCode: Binding<String?>) { _scannedCode = scannedCode }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
               let stringValue = metadataObject.stringValue {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                scannedCode = stringValue
                session?.stopRunning()
            }
        }
    }
}

// MARK: - Request/Response Models
struct QrLoginRequest: Codable { let qrCode: String }

struct QrLoginResponse: Codable {
    struct ChildData: Codable {
        let _id: String?
        let firstName: String
        let lastName: String
        let parent: String
        let status: String
    }
    let child: ChildData
    let access_token: String
}

// MARK: - Preview
#Preview {
    ScanQRCodeView()
}
