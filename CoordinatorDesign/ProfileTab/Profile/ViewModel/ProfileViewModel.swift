//
//  ProfileViewModel.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 26/02/26.
//

import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var menus = ["Single Image", "Multiple Image"]
    
    let coordinator: ProfileCoordinator
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    func selectedMenu(_ index: Int) {
        DispatchQueue.main.async { [weak self] in
            switch index {
            case 0:
                self?.coordinator.push(.single)
            case 1:
                self?.coordinator.push(.multiple)
            default:
                break
            }
        }
    }
    
    deinit {
        DispatchQueue.main.async { [weak self] in
            self?.menus = []
        }
    }
}
