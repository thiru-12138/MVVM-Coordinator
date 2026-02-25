//
//  MealListViewModel.swift
//  TestAPI
//
//  Created by Thirumalai Ganesh G on 27/01/26.
//

import Foundation
import Observation

@Observable
final class MealListViewModel {
    var meals: [Meals] = []
    var errorMessage: String?
    var isLoading = false
    var selectedCategory = "Chicken"
    let categories = ["Chicken",
                      "Beef",
                      "Vegetarian",
                      "Dessert",
                      "Pork",
                      "Seafood",
                      "Breakfast"]

    
    let usecase: MealUseCase
    let coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator, usecase: MealUseCase) {
        self.coordinator = coordinator
        self.usecase = usecase
    }

    private var task: Task<Void, Never>?
    
//    func loadData(_ category: String) async {
    func loadData() async {
        task?.cancel()
        isLoading = true
        
        task = Task {
            do {
                //let results = try await usecase.execute(category: category)
                let results = try await usecase.execute(category: selectedCategory)
                guard !Task.isCancelled else { return }
                await MainActor.run { [weak self] in
                    self?.meals = results
                    self?.isLoading = false
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }
    
    func selectMeal(_ mealid: String) {
        coordinator.push(.mealDetails(mealid: mealid))
    }

    deinit {
        task?.cancel()
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.meals = []
            self?.errorMessage = nil
        }
    }
}
