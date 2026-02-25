//
//  UserListView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Users Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundStyle(.red)
            } else {
                List(viewModel.users) { user in
                    Button(user.name) {
                        viewModel.selectUser(user)
                    }
                }
            }
        }
        .navigationTitle("Users")
        .task { [weak viewModel] in
            await viewModel?.loadUsers()
        }
    }
}
