//
//  MainView.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 07/12/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage



struct MainView: View {
    
    @State private var viewModel:ClientVM = ClientVM()
    
    let backgroundColorView:CatalogoColori = .seaTurtle_1
    @State private var tabSelector: Int = 0
    
    var body: some View {
        
        TabView(selection:$tabSelector) { // Deprecata da Apple / Sostituire
                
            QRScanView(backgroundColorView: backgroundColorView.color())
                   // .badge(dishChange)
                    .badge(0) // Il pallino rosso delle notifiche !!!
                    .tabItem {
                        Image(systemName: "menucard")
                        Text("Menu")
                    }.tag(0)

            PropertyVisitedView(backgroundColorView: backgroundColorView.color())
                .badge(0)
                .tabItem {
                    Image (systemName: "menucard")//scroll.fill
                    Text("Check-In")
                }.tag(1)
 
            }
        .environmentObject(viewModel)
        .accentColor(CatalogoColori.seaTurtle_3.color())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
   
            MainView()
        
    }
}
