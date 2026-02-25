//
//  ScreenAViewModel.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 02/02/26.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class ScreenAViewModel {
    private let coordinator: ProfileCoordinator
    private let imageService: ImageServiceProtocol
    private let cache: ImageCache
    var image: UIImage?
    var errMsg: String?
    var isLoading = false
    
    private var task: Task<Void, Never>?
    
    init(coordinator: ProfileCoordinator,
         imageService: ImageServiceProtocol,
         cache: ImageCache) {
        self.coordinator = coordinator
        self.imageService = imageService
        self.cache = cache
    }
    
    func loadImage() async {
        task?.cancel()
        errMsg = nil
        image = nil
        isLoading = true
        
        task = Task {
            do {
                let resultImage = try await fetchImage(urlStr: "https://picsum.photos/id/237/200/300")
                guard !Task.isCancelled else { return }
                await MainActor.run { [weak self] in
                    self?.image = resultImage
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.errMsg = error.localizedDescription
                }
            }
            
            isLoading = false
        }
    }

    func fetchImage(urlStr: String) async throws -> UIImage {
        guard let url = URL(string: urlStr) else {
            throw APIError.invalidURL //URLError(.badURL)
        }
        
        if let cached = cache.image(for: url) {
            return cached
        }

        let image = try await imageService.fetchImage(url: urlStr)
        cache.store(image, for: url)
        return image
    }
    
    func selectImage(_ image: UIImage) {
        coordinator.push(.imageDetail(image: image))
    }
    
    deinit {
        task?.cancel()
        isLoading = false
    }
}
