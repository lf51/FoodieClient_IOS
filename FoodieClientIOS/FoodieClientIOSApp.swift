//
//  FoodieClientIOSApp.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 07/12/22.
//

import SwiftUI
import Firebase

@main
struct FoodieClientIOSApp: App {
    
    init() {
        FirebaseApp.configure()
        // disattivare raccolta dati
    }
    var body: some Scene {
        WindowGroup {
           // ContentView()
            MainView()
        }
    }
}
