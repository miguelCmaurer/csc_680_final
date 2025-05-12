//
//  BigButton.swift
//  csc-680-final
//
//  Created by Miguel Maurer on 5/1/25.
//
import SwiftUI

struct BigButton: View {
    var content: String
    var action: () -> Void
    var type: String = "primary"

    var body: some View {
        Button(action: action) {
            Text(content)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    type == "primary" ? Color("forest_green") : Color.clear
                )
                .foregroundColor(
                    type == "primary" ? .white : Color("forest_green")
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("forest_green"), lineWidth: type == "outline" ? 2 : 0)
                )
                .cornerRadius(12)
                .shadow(
                    color: type == "primary" ? Color.black.opacity(0.2) : Color.clear,
                    radius: 4, x: 0, y: 2
                )
        }
        .padding(.horizontal, 20)
    }
}




#Preview {
    ContentView()
}

