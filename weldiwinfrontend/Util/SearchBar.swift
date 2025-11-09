//
//  SearchBar.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 9/11/2025.
//


import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search places"
    var onSubmit: (() -> Void)? = nil
    var onClear: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(red: 0.95, green: 0.55, blue: 0.35))
                .font(.system(size: 18, weight: .semibold))

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
                TextField("", text: $text, onCommit: {
                    onSubmit?()
                })
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .disableAutocorrection(true)
            }

            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onClear?()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
    }
}