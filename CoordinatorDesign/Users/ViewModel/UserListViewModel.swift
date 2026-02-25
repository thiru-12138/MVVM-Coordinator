//
//  UserListViewModel.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import Foundation
import Combine

@MainActor
final class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    let service: DataService
    let coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator, service: DataService) {
        self.coordinator = coordinator
        self.service = service
    }

    private var task: Task<Void, Never>?
    
    func loadUsers() async {
        task?.cancel()
        users = []
        errorMessage = nil
        isLoading = true
        
        task = Task {
            let url = Constants.Urls.Users
            do {
                let result: [User] = try await service.fetchRequest(url: url)
                guard !Task.isCancelled else { return }
                await MainActor.run { [weak self] in
                    self?.users = result
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.errorMessage = error.localizedDescription
                }
            }
            isLoading = false
        }
    }


    func selectUser(_ user: User) {
        coordinator.push(.userDetail(user))
    }
    
    deinit {
        task?.cancel()
        DispatchQueue.main.async(execute: { [weak self] in
            self?.isLoading = false
            self?.users = []
            self?.errorMessage = nil
        })
    }
}


