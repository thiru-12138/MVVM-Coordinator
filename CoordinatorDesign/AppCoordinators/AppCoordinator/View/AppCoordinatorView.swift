//
//  AppCoordinatorView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import SwiftUI

struct AppCoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var tabBarState = TabBarState()

    var body: some View {
        ZStack(alignment: .bottom, content: {
            Group(content: {
                switch coordinator.selectedTab {
                case .home:
                    HomeCoordinatorView()
                        .environmentObject(coordinator)
                    
                case .profile:
                    ProfileCoordinatorView()
                        .environmentObject(coordinator)
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if !tabBarState.isHidden {
                CustomBottomTabBar(selectedTab: $coordinator.selectedTab)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: tabBarState.isHidden)
            }
        })
        .environmentObject(tabBarState)
        .onAppear(perform: {
            let x = 1
            if x == 1 {
                print("Hello")
            }
            
            let items = [1, 2]
            if items.count == 0 {
                print("Empty")
            }
            
            if [1,2].count == 0 {
                print("bad")
            }
        })
    }
}


struct CustomBottomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    Spacer()
                    
                    VStack(spacing: 4.0) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text(tab.title).font(.caption)
                    }
                    .foregroundStyle(selectedTab == tab ? .purple : .gray)
                    .onTapGesture(perform: {
                        selectedTab = tab
                    })
                    
                    Spacer()
                }
            }
        }
    
    }
}
