//
//  PreSelectionView.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 11/01/23.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct PreSelectionView: View {
    
    @EnvironmentObject var viewModel:ClientVM
    
    let backgroundColorView:Color
    
    var body: some View {
        
      //  NavigationStack {
            
            CSZStackVB(
                title: "Pre Selezione",
                backgroundColorView: backgroundColorView) {
                    
                    let modelIds = self.viewModel.preSelectionRif
                    let container = self.viewModel.modelCollectionFromCollectionID(collectionId: modelIds, modelPath: \.allMyDish)
                    
                    VStack {
                        
                        CSDivider()
                        
                        ScrollView {
                            
                            ForEach(container) { selection in
                                
                                DishModelRow_ClientVersion(
                                    viewModel: viewModel,
                                    item: selection,
                                    rowColor: .seaTurtle_1) {
                                        self.viewModel.checkSelection(rif: selection.id)
                                    } selectorAction: {
                                        self.viewModel.preSelectionLogic(rif: selection.id)
                                    } reviewButton: {
                                        //
                                    }
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                        CSDivider()
                    }
                    
                    
                
                    
                    
                    
                    
                    
                    
            } // chiusa csZStack
            
            
            
            
      //  } // chiusa navStack
        
        
    }
}

/*
struct PreSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PreSelectionView()
    }
} */
