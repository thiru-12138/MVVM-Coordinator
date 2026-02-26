//
//  ProfileScreenView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 26/02/26.
//

import SwiftUI

struct ProfileScreenView: View {
    @StateObject var model: ProfileViewModel
    
    
    var body: some View {
        List(Array(model.menus.enumerated()), id: \.offset) { index, menu in
            Button(menu, action: {
                model.selectedMenu(index)
            })
        }
        .navigationTitle("Profile Screen")
    }
}

