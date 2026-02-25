//
//  ProfileCoordinatorView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 18/02/26.
//

import SwiftUI

struct ProfileCoordinatorView: View {
    @EnvironmentObject var tabBarState: TabBarState
    @StateObject private var coordinator = ProfileCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path, root: {
            // Initial Screen
            let imgservice = ImageService()
            let imgcache = ImageCache()
            ScreenAView(model: ScreenAViewModel(coordinator: coordinator,
                                                imageService: imgservice,
                                                cache: imgcache))
                .navigationDestination(for: ProfilePage.self) { page in
                    switch page {
                    case .imageDetail(let image):
                        ScreenBView(model: ScreenBViewModel(image: image))
                    }
                }
        })
        .environmentObject(tabBarState)
        .onChange(of: coordinator.path.count) { oldval, count in
            tabBarState.isHidden = count > 0
        }
    }
}

#Preview {
    ProfileCoordinatorView()
}
