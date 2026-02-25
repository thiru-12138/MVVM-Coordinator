//
//  MealUseCaseImlementation.swift
//  TestAPI
//
//  Created by Thirumalai Ganesh G on 27/01/26.
//

import Foundation

final class MealUseCaseImlementation: MealRepository {
    
    private let service: DataService
    
    init(service: DataService) {
        self.service = service
    }
    
    func getMeals(category: String) async throws -> [Meals] {
        let url = Constants.Urls.Meals + category //"\(category)" //"Chicken"
        let results: MealResponse = try await service.fetchRequest(url: url)
        return results.meals
    }
}

final class MealDetailUseCaseImlementation: MealDetailRepository {
    private let service: DataService
    
    init(service: DataService) {
        self.service = service
    }
    
    func getMealDetails(id: String) async throws -> [MealDetail] {
        let url = Constants.Urls.MealDetail + id //"\(id)"
        let results: MealDetailResponse = try await service.fetchRequest(url: url)
        return results.meals
    }
}
