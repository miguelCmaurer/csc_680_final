import SwiftUI
import SDWebImageSwiftUI

func stripHTMLTags(from html: String) -> String {
    let pattern = "<[^>]+>"
    return html.replacingOccurrences(of: pattern, with: "", options: .regularExpression, range: nil)
}


struct TrailCard: View {
    
    let facility: Facility

    @State private var index = 0

    var body: some View {
        let allImages = facility.MEDIA
        let imageCount = allImages.count
        let currentImageURL = imageCount > 0 ? allImages[index % imageCount].URL : nil

        HStack(alignment: .top, spacing: 16) {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .cornerRadius(12)

                if let urlString = currentImageURL,
                   let url = URL(string: urlString) {
                    WebImage(url: url)
                        .resizable()
                        .indicator(.activity)
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipped()
                        .cornerRadius(12)
                        .onTapGesture {
                            index += 1
                        }
                }

                if imageCount > 1 {
                    HStack(spacing: 4) {
                        ForEach(0..<min(6,imageCount), id: \.self) { i in
                            Circle()
                                .fill(i == (index % imageCount) ? Color.forestGreen : Color.gray.opacity(0.6))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom, 6)
                    .padding(.bottom, 8)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(facility.FacilityName.capitalized)
                    .font(.headline)

                Text(stripHTMLTags(from: facility.FacilityDescription))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
            }
        }
        .padding(.vertical, 10)
    }
}
