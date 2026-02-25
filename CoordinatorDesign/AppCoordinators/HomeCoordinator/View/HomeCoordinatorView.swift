//
//  HomeCoordinatorView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 18/02/26.
//

import SwiftUI

struct HomeCoordinatorView: View {
    @EnvironmentObject var tabBarState: TabBarState
    @StateObject private var coordinator = HomeCoordinator()
    private let apiservice = APIService()
    
    var body: some View {
        NavigationStack(path: $coordinator.path, root: {
            // Initial Screen
            HomeScreenView(model: HomeViewModel(coordinator: coordinator))
                .navigationDestination(for: HomePage.self) { page in
                    switch page {
                    case .userList:
                        UserListView(viewModel: UserListViewModel(coordinator: coordinator,
                                                                  service: apiservice))
                        
                    case .userDetail(let user):
                        UserDetailView(user: user)
                    case .postList:
                        PostListView(viewModel: PostListViewModel(coordinator: coordinator,
                                                                  service: apiservice))
                        
                    case .postDetails(let post):
                        PostDetailView(post: post)
                    case .mealList:
                        let repo = MealUseCaseImlementation(service: apiservice)
                        let usecase = MealUseCase(repository: repo)
                        MealListView(model: MealListViewModel(coordinator: coordinator,
                                                              usecase: usecase))
                    case .mealDetails(let mealid):
                        let repository = MealDetailUseCaseImlementation(service: apiservice)
                        let usecase = MealDetailUseCase(repository: repository)
                        MealDetailView(mealID: mealid,
                                       model: MealDetailViewModel(coordinator: coordinator,
                                                                  usecase: usecase))
                        
                    }
                }
        })
        .environmentObject(tabBarState)
        .onChange(of: coordinator.path.count) { oldval, count in
            print("Count: ", oldval, count)
            DispatchQueue.main.async {
                self.tabBarState.isHidden = count > 0
            }
        }
    }
}

#Preview {
    HomeCoordinatorView()
}
