import SwiftUI

struct TVHeading: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title).font(.system(size: 55, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                .minimumScaleFactor(0.65)
            Text(subtitle).font(.system(size: 28)).foregroundStyle(.white.opacity(0.7))
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
struct TVPrimaryButton: View {
    let title: String
    let symbol: String
    let focused: Bool
    var tint: Color = TVTheme.purple
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: symbol).font(.system(size: 28, weight: .bold))
                .frame(maxWidth: .infinity, minHeight: 58)
                .foregroundStyle(.white)
                .tvCard(focused: focused, tint: tint)
        }.buttonStyle(.plain).accessibilityLabel(title)
    }
}
struct TVStageBar: View {
    let title: String
    let detail: String
    var body: some View {
        HStack {
            Text(title).font(.system(size: 30, weight: .bold))
            Spacer()
            Text(detail).font(.system(size: 24)).foregroundStyle(.white.opacity(0.75))
        }.foregroundStyle(.white).padding(.vertical, 16)
    }
}
