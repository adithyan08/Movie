import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    let onRefresh: () async -> Void
    let content: Content
    
    @State private var isRefreshing = false
    
    init(
        onRefresh: @escaping () async -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.onRefresh = onRefresh
        self.content = content()
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            ScrollView {
                content
            }
            .refreshable {
                await onRefresh()
            }
        } else {
            // iOS 14 fallback with manual refresh
            ScrollView {
                VStack(spacing: 0) {
                    // Simple pull-to-refresh indicator
                    if isRefreshing {
                        HStack {
                            Spacer()
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Refreshing...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    
                    content
                }
            }
            .overlay(
                // Add refresh button for iOS 14
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            Task {
                                isRefreshing = true
                                await onRefresh()
                                isRefreshing = false
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .padding()
                                .background(Color(.systemBackground))
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .disabled(isRefreshing)
                        .padding(.trailing)
                        .padding(.top, 60) // Account for navigation bar
                    }
                    Spacer()
                }
            )
        }
    }
}

// MARK: - Loading Row View (iOS 14+ Compatible)
struct LoadingRowView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

// MARK: - Search Bar View
struct SearchBarView: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search movies...", text: $text, onEditingChanged: { editing in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isEditing = editing
                    }
                })
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            if isEditing {
                Button("Cancel") {
                    text = ""
                    isEditing = false
                    hideKeyboard()
                }
                .foregroundColor(.red)
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isEditing)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}





// MARK: - Compatible AsyncImage for iOS 14+
struct CompatibleAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @StateObject private var imageLoader = ImageLoader()
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                content(Image(uiImage: image))
            } else if imageLoader.isLoading {
                placeholder()
            } else {
                placeholder()
            }
        }
        .onAppear {
            imageLoader.load(url: url)
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }
}

// Enhanced ImageLoader with better caching
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private var task: URLSessionDataTask?
    private static let cache = NSCache<NSURL, UIImage>()
    
    static let shared = ImageLoader() // Singleton for prefetching
    
    init() {
        // Configure cache limits
        Self.cache.countLimit = 200
        Self.cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func load(url: URL?) {
        guard let url = url else { return }
        
        // Check cache first for instant loading
        if let cachedImage = Self.cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                self.image = cachedImage
                self.isLoading = false
            }
            return
        }
        
        // Avoid duplicate requests
        guard task?.originalRequest?.url != url else { return }
        
        isLoading = true
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            defer {
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
            
            guard let data = data,
                  let downloadedImage = UIImage(data: data),
                  error == nil else { return }
            
            // Cache the image
            Self.cache.setObject(downloadedImage, forKey: url as NSURL)
            
            DispatchQueue.main.async {
                self?.image = downloadedImage
            }
        }
        
        task?.priority = URLSessionTask.highPriority
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
        task = nil
        isLoading = false
    }
}





struct MovieCardView: View {
    let movie: Movie
    @EnvironmentObject private var localStorage: LocalStorageService

    var body: some View {
        
        NavigationLink(destination: MovieDetailView(movie: movie)) {
            VStack(spacing: 8) {
                // Image section
                ZStack(alignment: .topTrailing) {
                   
                    CompatibleAsyncImage(url: movie.posterURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        EmptyStateView(message: "Movie App")
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(2/3, contentMode: .fit)
                    .clipped()
                    .cornerRadius(12)

                    // Favorite button
                    Button {
                        localStorage.toggleFavorite(movie.id)
                    } label: {
                        Image(systemName: localStorage.isFavorite(movie.id) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .padding(6)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding(8)
                }

                // Text section
                VStack(alignment: .center, spacing: 5) {
                    Text(movie.title)
                        .font(.subheadline)
                        .lineLimit(0)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 4) {
                        Label(movie.formattedVoteAverage, systemImage: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Spacer()
                        Text(movie.formattedReleaseDate)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            .frame(maxWidth: .infinity) // fill grid cell
        }.buttonStyle(PlainButtonStyle())
            .accessibilityLabel("Movie: \(movie.title)")
            .accessibilityHint("Tap to view details")
       
    }
}
struct MovieCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMovie = Movie(
            id: 1,
            title: "Sample Movie",
            overview: "This is a sample movie overview.",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: "2024-01-01",
            voteAverage: 8.5,
            voteCount: 1000,
            popularity: 100.0,
            adult: false,
            originalLanguage: "en",
            originalTitle: "Sample Movie",
            genreIds: [28, 12]
        )
        
        MovieCardView(movie: sampleMovie)
            .environmentObject(LocalStorageService.shared)
            .frame(width: 160, height: 280)
            .previewLayout(.sizeThatFits)
    }
}
