//
//  ProfileCoordinator.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 18/02/26.
//

import Foundation
import SwiftUI
import Combine

enum ProfilePage: Hashable {
    case imageDetail(image: UIImage)
}

@MainActor
class ProfileCoordinator: ObservableObject {
    //@Published var path = NavigationPath()
    @Published var path : [ProfilePage] = []

    func push(_ page: ProfilePage) {
        guard path.last != page else { return }
        DispatchQueue.main.async { [weak self] in
            self?.path.append(page)
        }
    }
    
    func pop() {
        DispatchQueue.main.async { [weak self] in
            self?.path.removeLast()
        }
    }
    
}
