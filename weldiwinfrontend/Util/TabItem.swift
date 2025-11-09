//
//  CustomTabBar.swift
//  weldiwinfrontend
//
//  Created by sayari amin
//

import SwiftUI
import UIKit

// MARK: - Tab Items Enum

enum TabItem: Int, CaseIterable {
    case home = 0
    case child = 1
    case location = 2
    case activity = 3
    case profile = 4
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .child: return "Child"
        case .location: return "Location"
        case .activity: return "Activity"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .child: return "figure.2.and.child.holdinghands"
        case .location: return "location.fill"
        case .activity: return "bell.fill"
        case .profile: return "person.fill"
        }
    }
}

// MARK: - Main TabBar View

struct CustomTabBarView: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // ✅ Tab Content
            Group {
                switch selectedTab {
                case .home:
                    HomePage()
                case .child:
                    ParentsChildrenSwiftUIView()
                case .location:
                    LocationView()
                case .activity:
                    ActivityPlaceholderView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.keyboard)
            
            // ✅ Transparent Floating Tab Bar
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(TabItem.allCases, id: \.self) { tab in
                        TabBarButton(
                            tab: tab,
                            isSelected: selectedTab == tab,
                            action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedTab = tab
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                .padding(.bottom, safeAreaBottom() + 6)
            }
            .background(
                Color.clear // ✅ No blur, no tint, fully transparent
                    .ignoresSafeArea(edges: .bottom)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, y: -2)
        }
    }
    
    private func safeAreaBottom() -> CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets.bottom ?? 0
    }
}

// MARK: - Tab Button

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 22, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? Color(red: 0.95, green: 0.55, blue: 0.35) : .black.opacity(0.75))
                    .frame(height: 26)
                
                Text(tab.title)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color(red: 0.95, green: 0.55, blue: 0.35) : .black.opacity(0.75))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
    }
}

// MARK: - Placeholder Activity View

struct ActivityPlaceholderView: View {
    var body: some View {
        ZStack {
            Image("iPhone 16 Pro - 8")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35).opacity(0.4))
                
                Text("Activity")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundColor(.black.opacity(0.85))
                
                Text("Coming soon...")
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.6))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CustomTabBarView()
}
