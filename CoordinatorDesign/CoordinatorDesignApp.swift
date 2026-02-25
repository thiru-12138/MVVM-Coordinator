//
//  CoordinatorDesignApp.swift
//  CoordinatorDesign
//
//  Created by Thirumalai Ganesh G on 31/01/26.
//

import SwiftUI
import CoreData

@main
struct CoordinatorDesignApp: App {
    //let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            //ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
            AppCoordinatorView()
                .onAppear(perform: {
                    if let path = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
                        print("path: ", path)
                    }
                })
        }
    }
}
