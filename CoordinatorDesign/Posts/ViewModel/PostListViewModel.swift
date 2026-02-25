//
//  PostListViewModel.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import Foundation
import Combine

@MainActor
final class PostListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading = false
    
    let service: DataService
    let coordinator: HomeCoordinator
    private var task: Task<Void, Never>?

    init(coordinator: HomeCoordinator, service: DataService) {
        self.coordinator = coordinator
        self.service = service
    }

    func loadPosts() async {
        task?.cancel()
        posts = []
        errorMessage = nil
        isLoading = true
        
        let url = Constants.Urls.Posts
        do {
            let results: [Post] = try await service.fetchRequest(url: url)
            guard !Task.isCancelled else { return }
            await MainActor.run { [weak self] in
                self?.posts = results
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }

    func selectPost(_ post: Post) {
        coordinator.push(.postDetails(post))
    }
    
    deinit {
        task?.cancel()
        DispatchQueue.main.async(execute: { [weak self] in
            self?.posts = []
            self?.errorMessage = nil
            self?.isLoading = true
        })
    }
    
}
