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
        DispatchQueue.main.async { [weak self] in
            switch index {
            case 0:
                self?.coordinator.push(.userList)
            case 1:
                self?.coordinator.push(.postList)
            case 2:
                self?.coordinator.push(.mealList)
                
            default:
                break
            }
        }
    }
    
    deinit {
        DispatchQueue.main.async(execute: { [weak self] in
            self?.menus = []
        })
    }
}
