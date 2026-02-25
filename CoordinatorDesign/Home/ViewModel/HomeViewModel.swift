//
//  HomeViewModel.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var menus = ["Users", "Posts", "Meals"]
    
    let coordinator: HomeCoordinator

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

    func selectMenu(_ index: Int) {
        switch index {
        case 0:
            coordinator.push(.userList)
        case 1:
            coordinator.push(.postList)
        case 2:
            coordinator.push(.mealList)
            
        default:
            break
        }
    }
    
    deinit {
        DispatchQueue.main.async(execute: { [weak self] in
            self?.menus = []
        })
    }
}
