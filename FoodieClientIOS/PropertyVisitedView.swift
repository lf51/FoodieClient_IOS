//
//  PropertyVisitedView.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 12/12/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct PropertyVisitedView: View {
    
    @EnvironmentObject var viewModel:ClientVM
    
    let backgroundColorView:Color
    
    var body: some View {
        
        NavigationStack {
            
            CSZStackVB(title: "Check-In", backgroundColorView: backgroundColorView) {
               
                VStack {
                    
                    if self.viewModel.checkInProperties.isEmpty {
                        
                        
                        Text("Elenco Vuoto")
     
                        
                    } else {
                        
                        VStack {
                            
                            ForEach(viewModel.checkInProperties) { property in
                                
                                Text(property.intestazione)
                                    .foregroundColor(Color.black)
                                
                                
                                
                            }
                            
                        }

                    }
                }
                
                
                
            }
        }
    }
}

struct PropertyVisitedView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyVisitedView(backgroundColorView: .seaTurtle_1)
    }
}
