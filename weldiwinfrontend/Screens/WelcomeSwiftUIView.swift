import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Same background as other pages
                Image("iPhone 16 Pro - 8")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Image placeholder icon
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color(red: 0.95, green: 0.55, blue: 0.35), lineWidth: 4)
                        .frame(width: 130, height: 95)
                        .overlay(
                            VStack(spacing: 8) {
                                Circle()
                                    .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                                    .frame(width: 8, height: 8)
                                    .offset(x: -25, y: -8)
                                
                                Path { path in
                                    path.move(to: CGPoint(x: 20, y: 35))
                                    path.addLine(to: CGPoint(x: 45, y: 15))
                                    path.addLine(to: CGPoint(x: 70, y: 25))
                                    path.addLine(to: CGPoint(x: 90, y: 35))
                                }
                                .stroke(Color(red: 0.95, green: 0.55, blue: 0.35), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .frame(width: 110, height: 40)
                                .offset(y: -5)
                            }
                        )
                        .padding(.bottom, 200)
                    
                    // Title
                    Text("Welcome to App")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.black.opacity(0.9))
                        .padding(.bottom, 16)
                    
                    // Subtitle
                    VStack(spacing: 4) {
                        Text("Here's a good place for a brief overview")
                            .font(.system(size: 17))
                            .foregroundStyle(.gray.opacity(0.85))
                        Text("of the app or it's key features.")
                            .font(.system(size: 17))
                            .foregroundStyle(.gray.opacity(0.85))
                    }
                    .padding(.bottom, 50)
                    
                    // Page indicators
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(.gray.opacity(0.25))
                            .frame(width: 12, height: 12)
                    }
                    .padding(.bottom, 80)
                    
                    // Get started button with navigation
                    NavigationLink(destination: SignInView()) {
                        Text("Get started")
                            .font(.system(size: 20, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 62)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color(red: 0.95, green: 0.55, blue: 0.35))
                                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                            )
                    }
                    .padding(.horizontal, 36)
                    .padding(.bottom, 60)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    OnboardingView()
}
