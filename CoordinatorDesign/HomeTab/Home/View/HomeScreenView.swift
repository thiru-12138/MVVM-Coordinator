//
//  HomeScreenView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import SwiftUI

struct HomeScreenView: View {
    @StateObject var model: HomeViewModel
    
    var body: some View {
        List(Array(model.menus.enumerated()), id: \.offset) { index, menu in
            Button(menu) {
                model.selectMenu(index)
            }
        }
        .navigationTitle("Home Screen")
    }
}

