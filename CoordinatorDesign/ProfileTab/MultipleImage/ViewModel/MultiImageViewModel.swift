//
//  MultiImageViewModel.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 26/02/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class MultiImageViewModel: ObservableObject {
    @Published var images: [UIImage?] = Array(repeating: nil, count: 10)
    
    @Published var errorMsg: String?
    
    let coordinator: ProfileCoordinator
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    private let urls: [URL] = (1...10).map { URL(string: "https://picsum.photos/id/\($0)/300")! }
    private var task: Task<Void, Never>?
    
    func downloadAllImages() async {
        task?.cancel()
        images = Array(repeating: nil, count: 10)
        errorMsg = nil
        
        task = Task {
            await withTaskGroup(of: (Int, UIImage?).self) { group in
                
                for (index, url) in urls.enumerated() {
                    group.addTask(operation: {
                        let image = await self.downloadImage(at: url)
                        return (index, image)
                    })
                }
                
                for await (index, image) in group {
                    guard !Task.isCancelled else { return }
                    await MainActor.run { [weak self] in
                        self?.images[index] = image
                    }
                }
                
            }
        }
    }
    
//    private func downloadImage1(at url: URL) async -> UIImage? {
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            return UIImage(data: data)
//        } catch {
//            print("❌ Error downloading image from \(url): \(error)")
//            await MainActor.run { [weak self] in
//                self?.errorMsg = error.localizedDescription
//            }
//            return nil
//        }
//    }
    
    private func downloadImage(at url: URL) async -> UIImage?  {
        // 1. Try cache first
        if let cached = LRUImageCache.shared.get(url) {
            return cached
        }
        
        // 2. Download image
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let download = UIImage(data: data) {
                LRUImageCache.shared.set(url, image: download)
                return download
            }
        } catch {
            print("Image download failed:", error)
        }
        return nil
    }

    
    func selectedImage(_ image: UIImage) async {
        await MainActor.run { [weak self] in
            self?.coordinator.push(.imageDetail(image: image))
        }
    }
    
    deinit {
        task?.cancel()
        DispatchQueue.main.async { [weak self] in
            self?.images = []
            self?.errorMsg = nil
        }
    }
}
