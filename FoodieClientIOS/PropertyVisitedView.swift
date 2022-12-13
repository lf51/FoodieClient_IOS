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
                    
                    if let all = viewModel.cloudData?.allMyDish {
                        
                        if all.isEmpty { Text("Elenco Vuoto")}
                        else {
                            
                            VStack {
                                
                                ForEach(all) { dish in
                                    
                                    Text(dish.id)
                                        .foregroundColor(Color.black)
                                    
                                    
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                        
                    } else {
                        
                        Text("Cloud Data not Exist")
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
            }
        }
    }
}

struct PropertyVisitedView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyVisitedView(backgroundColorView: CatalogoColori.seaTurtle_1.color())
    }
}
