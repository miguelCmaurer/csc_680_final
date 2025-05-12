import SwiftUI

struct ActivityButton: View {
    let label: String
    let iconName: String
    let action: () -> Void
    var color: Color = .blue

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(color.mix(with: .white, by: 0.7))

                Text(label)
                    .fontWeight(.medium)
                    .foregroundColor(color.mix(with: .white, by: 0.8))
                    .font(.caption)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
