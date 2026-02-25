//
//  MealDetailViewModel.swift
//  TestAPI
//
//  Created by Thirumalai Ganesh G on 27/01/26.
//

import Foundation
import Observation

@Observable
final class MealDetailViewModel {
    var mealDetail: [MealDetail] = []
    var errorMeassage: String?
    var isLoading = false
    
    let usecase: MealDetailUseCase
    let coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator, usecase: MealDetailUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }

    private var task: Task<Void, Never>?
    
    func fetchDetails(_ mealid: String) async {
        task?.cancel()
        mealDetail = []
        errorMeassage = nil
        isLoading = true
        
        task = Task {
            do {
                let results = try await usecase.execute(mid: mealid)
                guard !Task.isCancelled else { return }
                await MainActor.run { [weak self] in
                    self?.mealDetail = results
                    self?.isLoading = false
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.errorMeassage = error.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }
    
    deinit {
        task?.cancel()
        DispatchQueue.main.async(execute: { [weak self] in
            self?.isLoading = false
            self?.mealDetail = []
            self?.errorMeassage = nil
        })
    }
}
