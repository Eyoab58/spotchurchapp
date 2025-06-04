import SwiftUI

struct RemoteImageView: View {
    let urlString: String

    @State private var uiImage: UIImage? = nil
    @State private var isLoading = true

    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .clipped()
            } else if isLoading {
                ProgressView()
                    .frame(height: 180)
            } else {
                VStack {
                    Color.red.frame(height: 180).cornerRadius(12)
                    Text("Failed to load image").foregroundColor(.white)
                }
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }

        let config = URLSessionConfiguration.default
        #if targetEnvironment(simulator)
        config.tlsMinimumSupportedProtocolVersion = .TLSv12
        config.tlsMaximumSupportedProtocolVersion = .TLSv12
        #endif
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                isLoading = false
                if let data = data, let img = UIImage(data: data) {
                    self.uiImage = img
                }
            }
        }

        task.resume()
    }
}
