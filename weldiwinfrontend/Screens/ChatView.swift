//
//  ChatView.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 9/11/2025.
//

import Foundation
import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Hello! How is our little one doing today? 👶", senderId: "parent1", senderName: "Kamel", timestamp: Date().addingTimeInterval(-3600)),
        ChatMessage(text: "He's doing great! Just finished his lunch 🍎", senderId: "currentUser", senderName: "You", timestamp: Date().addingTimeInterval(-3400), isFromCurrentUser: true),
        ChatMessage(text: "That's wonderful! Did he eat everything?", senderId: "parent1", senderName: "Kamel", timestamp: Date().addingTimeInterval(-3300)),
        ChatMessage(text: "Yes! He loved the apple slices 😊", senderId: "currentUser", senderName: "You", timestamp: Date().addingTimeInterval(-3200), isFromCurrentUser: true),
        ChatMessage(text: "Perfect! See you at pickup time 👋", senderId: "parent1", senderName: "Kamel", timestamp: Date().addingTimeInterval(-3100))
    ]
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Background gradient matching app theme
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.95, blue: 0.90),
                    Color(red: 0.99, green: 0.93, blue: 0.87)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // HEADER - Matching app design
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        // Back button
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                                .frame(width: 40, height: 40)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                        }
                        
                        // Contact info
                        HStack(spacing: 12) {
                            // Avatar
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
                                    .frame(width: 52, height: 52)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                
                                // Online indicator
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 14, height: 14)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2.5)
                                    )
                                    .offset(x: 18, y: 18)
                            }
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Kamel Sayari")
                                    .font(.system(size: 18, weight: .bold, design: .serif))
                                    .foregroundColor(.black.opacity(0.85))
                                
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 8, height: 8)
                                    Text("Active now")
                                        .font(.system(size: 14))
                                        .foregroundColor(.black.opacity(0.55))
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Action buttons
                        HStack(spacing: 12) {
                            Button(action: {
                                // Video call action
                            }) {
                                Image(systemName: "video.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                                    .frame(width: 40, height: 40)
                                    .background(Color.white.opacity(0.9))
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                            }
                            
                            Button(action: {
                                // Call action
                            }) {
                                Image(systemName: "phone.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                                    .frame(width: 40, height: 40)
                                    .background(Color.white.opacity(0.9))
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, safeTop() + 12)
                    .padding(.bottom, 16)
                }
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.85))
                        .shadow(color: Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.15), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                
                // MESSAGES AREA
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 16) {
                            // Date separator
                            Text("Today")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.black.opacity(0.45))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.7))
                                        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                                )
                                .padding(.top, 16)
                                .padding(.bottom, 8)
                            
                            ForEach(messages) { msg in
                                MessageBubble(message: msg)
                                    .id(msg.id)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation {
                            if let last = messages.last {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // INPUT BAR
                VStack(spacing: 0) {
                    Divider()
                        .background(Color.black.opacity(0.08))
                    
                    HStack(spacing: 12) {
                        // Attachment button
                        Button(action: {
                            // Attachment action
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                        }
                        
                        // Text field
                        HStack(spacing: 8) {
                            TextField("Type a message...", text: $messageText)
                                .font(.system(size: 16))
                                .focused($isTextFieldFocused)
                                .padding(.vertical, 12)
                                .padding(.leading, 16)
                            
                            // Emoji button
                            Button(action: {
                                // Emoji picker
                            }) {
                                Image(systemName: "face.smiling")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black.opacity(0.4))
                                    .padding(.trailing, 12)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.white.opacity(0.9))
                        )
                        
                        // Send button
                        Button(action: sendMessage) {
                            Image(systemName: messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "mic.fill" : "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                                .rotationEffect(.degrees(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0 : 0))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        Color.white.opacity(0.95)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: -2)
                    )
                    .padding(.bottom, safeBottom())
                }
            }
        }
        .navigationBarHidden(true)
        .onTapGesture {
            isTextFieldFocused = false
        }
    }
    
    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let msg = ChatMessage(
            text: trimmed,
            senderId: "currentUser",
            senderName: "You",
            timestamp: Date(),
            isFromCurrentUser: true
        )
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            messages.append(msg)
        }
        messageText = ""
    }
    
    private func safeTop() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 44
    }
    
    private func safeBottom() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.bottom ?? 0
    }
}

// MARK: - Message Bubble

private struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromCurrentUser {
                Spacer(minLength: 60)
            }
            
            // Show avatar for received messages
            if !message.isFromCurrentUser {
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
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(message.senderName.prefix(1).uppercased())
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                // Message bubble
                Text(message.text)
                    .font(.system(size: 16))
                    .foregroundColor(message.isFromCurrentUser ? .white : .black.opacity(0.85))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        Group {
                            if message.isFromCurrentUser {
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.98, green: 0.65, blue: 0.45),
                                        Color(red: 0.95, green: 0.55, blue: 0.35)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            } else {
                                Color.white.opacity(0.95)
                            }
                        }
                    )
                    .clipShape(
                        RoundedBubbleShape(
                            isFromCurrentUser: message.isFromCurrentUser
                        )
                    )
                    .shadow(
                        color: message.isFromCurrentUser
                            ? Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.25)
                            : Color.black.opacity(0.06),
                        radius: 6,
                        x: 0,
                        y: 3
                    )
                
                // Timestamp
                HStack(spacing: 4) {
                    Text(timeString(from: message.timestamp))
                        .font(.system(size: 11))
                        .foregroundColor(.black.opacity(0.4))
                    
                    // Read receipt for sent messages
                    if message.isFromCurrentUser {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.6))
                    }
                }
                .padding(.horizontal, 4)
            }
            
            if !message.isFromCurrentUser {
                Spacer(minLength: 60)
            }
        }
    }
    
    private func timeString(from date: Date) -> String {
        let fmt = DateFormatter()
        fmt.timeStyle = .short
        return fmt.string(from: date)
    }
}

// MARK: - Custom Bubble Shape

struct RoundedBubbleShape: Shape {
    let isFromCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 18
        let tailSize: CGFloat = 8
        
        var path = Path()
        
        if isFromCurrentUser {
            // Sent message bubble (right side with tail)
            path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: .degrees(-90),
                       endAngle: .degrees(0),
                       clockwise: false)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius - tailSize))
            path.addLine(to: CGPoint(x: rect.maxX + tailSize, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                       radius: radius,
                       startAngle: .degrees(90),
                       endAngle: .degrees(180),
                       clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: .degrees(180),
                       endAngle: .degrees(270),
                       clockwise: false)
        } else {
            // Received message bubble (left side with tail)
            path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: .degrees(-90),
                       endAngle: .degrees(0),
                       clockwise: false)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                       radius: radius,
                       startAngle: .degrees(0),
                       endAngle: .degrees(90),
                       clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX - tailSize, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - radius - tailSize))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: .degrees(180),
                       endAngle: .degrees(270),
                       clockwise: false)
        }
        
        return path
    }
}

#Preview {
    ChatView()
}
