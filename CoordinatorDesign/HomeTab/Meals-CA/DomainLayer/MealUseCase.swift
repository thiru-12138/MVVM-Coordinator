//
//  MealUseCase.swift
//  TestAPI
//
//  Created by Thirumalai Ganesh G on 27/01/26.
//

import Foundation

final class MealUseCase {
    private let repository: MealRepository
    
    init(repository: MealRepository) {
        self.repository = repository
    }
    
    func execute(category: String) async throws -> [Meals] {
        try await repository.getMeals(category: category)
    }
}

final class MealDetailUseCase {
    private let repository: MealDetailRepository
    
    init(repository: MealDetailRepository) {
        self.repository = repository
    }
    
    func execute(mid: String) async throws -> [MealDetail] {
        try await repository.getMealDetails(id: mid)
    }
}
