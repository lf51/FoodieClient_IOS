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
    
    let backgroundColorView:CatalogoColori = .seaTurtle_1
    @State private var tabSelector: Int = 0
    
    var body: some View {
        
        TabView(selection:$tabSelector) { // Deprecata da Apple / Sostituire
                
            QRScanView(backgroundColorView: backgroundColorView.color())
                   // .badge(dishChange)
                    .badge(0) // Il pallino rosso delle notifiche !!!
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }.tag(0)

            PropertyVisited(backgroundColorView: backgroundColorView.color())
                .badge(0)
                .tabItem {
                    Image (systemName: "menucard")//scroll.fill
                    Text("Menu")
                }.tag(1)
 
            }
        .accentColor(CatalogoColori.seaTurtle_3.color())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
   
            MainView()
        
    }
}



struct PropertyVisited:View {
    
    let backgroundColorView:Color
    
    var body: some View {
        
        NavigationStack {
            CSZStackVB(title: "Check-In", backgroundColorView: backgroundColorView) {
                Text("Lista proprietà scannerizzate")
            }
        }
    }
}
