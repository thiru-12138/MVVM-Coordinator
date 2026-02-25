//
//  UserDetailView.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(user.name).font(.largeTitle)
            Text(user.email).foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("User Details")
    }
}

//#Preview {
//    UserDetailView()
//}
