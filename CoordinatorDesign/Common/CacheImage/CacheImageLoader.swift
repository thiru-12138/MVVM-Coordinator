//
//  CacheImageLoader.swift
//  Pasikudhey
//
//  Created by Thirumalai Ganesh G on 16/02/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class CacheImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func load() async {
        // 1. Try cache first
        if let cached = LRUImageCache.shared.get(url) {
            await MainActor.run { [weak self] in
                self?.image = cached
            }
            return
        }
        
        // 2. Download image
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let download = UIImage(data: data) {
                LRUImageCache.shared.set(url, image: download)
                await MainActor.run { [weak self] in
                    self?.image = download
                }
            }
        } catch {
            print("Image download failed:", error)
        }
    }
}
