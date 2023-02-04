//
//  PreSelectionView.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 11/01/23.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
/*
struct PreSelectionView: View {
    
    @EnvironmentObject var viewModel:ClientVM
    
    let backgroundColorView:Color
    @State private var currentDishForRatingList:DishModel?
    
    var body: some View {
        
      //  NavigationStack {
            
            CSZStackVB(
                title: "Preferiti",
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
                                    rowColor: backgroundColorView,
                                    rowOpacity: 0.15,
                                    rowBoundReduction: 20,
                                    vistaEspansa: true) {
                                        self.viewModel.checkSelection(rif: selection.id)
                                    } selectorAction: {
                                        self.viewModel.preSelectionLogic(rif: selection.id)
                                    } reviewButton: {
                                        self.currentDishForRatingList = selection
                                    }
                                
                                
                            }
                            
                            
                            
                        }
     
                        CSDivider()
                    }
      
            } // chiusa csZStack
                .popover(
                    item: $currentDishForRatingList,
                    attachmentAnchor: .point(.trailing),
                    arrowEdge: .trailing,
                    content: { dish in
                  
                    DishRatingListView(
                     dishItem: dish,
                     backgroundColorView: backgroundColorView,
                     readOnlyViewModel: self.viewModel)
                    .presentationDetents([.height(650)])
                    
                })

      //  } // chiusa navStack

    }
} */ // Deprecata 24.01.23

/*
struct PreSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PreSelectionView()
    }
} */
