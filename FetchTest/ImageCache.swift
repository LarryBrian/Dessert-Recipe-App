//
//  ImageCache.swift
//  FetchTest
//
//  Created by Brian King on 6/11/24.
//

import Foundation
import SwiftUI
import Combine

class ImageCache {
    static let shared = ImageCache()
    
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

struct CachedAsyncImage<Content: View>: View {
    private let url: URL
    private let content: (Image) -> Content
    @State private var image: UIImage?
    @State private var cancellable: AnyCancellable?
    
    init(url: URL, @ViewBuilder content: @escaping (Image) -> Content) {
        self.url = url
        self.content = content
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else {
                ProgressView()
                    .onAppear(perform: loadImage)
            }
        }
    }
    
    private func loadImage() {
        if let cachedImage = ImageCache.shared.getImage(forKey: url.absoluteString) {
            self.image = cachedImage
        } else {
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .handleEvents(receiveOutput: { image in
                    if let image = image {
                        ImageCache.shared.setImage(image, forKey: url.absoluteString)
                    }
                })
                .receive(on: DispatchQueue.main)
                .assign(to: \.image, on: self)
        }
    }
}
