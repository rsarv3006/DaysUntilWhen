import SwiftUI

public struct PageHeader: View {
    private let systemName: String
    private let title: String
    private let subtitle: String
    
    public init(imageName systemName: String, title: String, subtitle: String) {
        self.systemName = systemName
        self.title = title
        self.subtitle = subtitle
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: systemName)
                    .foregroundColor(.blue)
                    .font(.system(size: 20, weight: .medium))
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}
