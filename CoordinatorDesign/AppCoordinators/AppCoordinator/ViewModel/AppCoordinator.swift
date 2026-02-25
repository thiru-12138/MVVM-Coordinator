//
//  AppCoordinator.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import Foundation
import SwiftUI
import Combine

enum TabItem: Hashable, CaseIterable {
    case home
    case profile
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .profile:
            return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .profile:
            return "person"
        }
    }
}

@MainActor
class AppCoordinator: ObservableObject {
    @Published var selectedTab: TabItem = .home
}

@MainActor
final class TabBarState: ObservableObject {
    @Published var isHidden: Bool = false
}
