//
//  DestinationPath.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 11/01/23.
//

import Foundation
import SwiftUI
import MyFoodiePackage

public enum DestinationPathView:Hashable {

case preSelezionePiatti
    
    @ViewBuilder func destinationAdress(backgroundColorView: Color, readOnlyViewModel:ClientVM) -> some View {
        
        switch self {
            
        case .preSelezionePiatti:
            PreSelectionView(
                backgroundColorView: backgroundColorView)
        }
        
    }
}

/*
enum DestinationPath {
   
   case scanView
   case propertyList
   
} */
