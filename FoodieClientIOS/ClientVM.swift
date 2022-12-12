//
//  ClientVM.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 08/12/22.
//

import Foundation
import MyFoodiePackage

class ClientVM: MyProViewModelPack_L1 {
    
    var allMyIngredients: [IngredientModel] = []
    var allMyDish: [DishModel] = []
    var allMyMenu: [MenuModel] = []
    var allMyProperties: [PropertyModel] = []
    var allMyCategories: [CategoriaMenu] = []
    var allMyReviews: [DishRatingModel] = []
    
    // 12.12.22 Non usiamo direttamente gli array sopra ma usiamo un dataCloud. Dovremmo trasformare in tal senso anche Foodie Business. Step by Step
    
    var cloudData: CloudDataStore = CloudDataStore()
    
    
    
    
}
