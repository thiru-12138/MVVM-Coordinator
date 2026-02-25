//
//  HomeCoordinator.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 18/02/26.
//

import Foundation
import Combine
import SwiftUI

enum HomePage: Hashable {
    case userList
    case userDetail(User)
    case postList
    case postDetails(Post)
    case mealList
    case mealDetails(mealid: String)
}

@MainActor
class HomeCoordinator: ObservableObject {
    //@Published var path = NavigationPath()
    @Published var path: [HomePage] = []

    // Helper to push pages
    func push(_ page: HomePage) {
        guard path.last != page else { return }
        DispatchQueue.main.async { [weak self] in
            self?.path.append(page)
        }
    }
    
    // Helper to pop back
    func pop() {
        DispatchQueue.main.async { [weak self] in
            self?.path.removeLast()
        }
    }
    
}
