//
//  ClientVM.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 08/12/22.
//

import Foundation
import MyFoodiePackage
import Firebase

class ClientVM: MyProViewModelPack_L1 {
    
    var allMyIngredients: [IngredientModel] = []
    var allMyDish: [DishModel] = []
    var allMyMenu: [MenuModel] = []
    var allMyProperties: [PropertyModel] = []
    var allMyCategories: [CategoriaMenu] = []
    var allMyReviews: [DishRatingModel] = []
    
    // 12.12.22 Non usiamo direttamente gli array sopra ma usiamo un dataCloud. Dovremmo trasformare in tal senso anche Foodie Business. Step by Step
    
    @Published var cloudData: CloudDataStore?
    var cloudDataCompiler:CloudDataCompiler?
    
    init() {
        
        // 1. Caricare dati salvati sullo userDefault. Dati sintetici in stringa per ricostruire data del check-in, luogo, città, ed eventuale recensione. Costruire un dictionary
        
    }
    
    func commpilaCloudDataFromUserDefault() {
        
        // Crea una istanza di CloudDataStore con i dati salvati localmente sul device
    }
    
    func compilaCloudDataFromFirebase() {
        
        guard let compiler = self.cloudDataCompiler else { return }
        
        compiler.compilaCloudDataFromFirebase { cloudData in
            self.cloudData = cloudData
        }
        
        print("ClientVM/compilaCloudDataFromFirebase")
        
    }
    
    
}

struct CloudDataCompiler {
    
    private let db_base = Firestore.firestore()
    private let ref_userDocument: DocumentReference?
  //  private let userUID: String?
    
    init(userUID:String?) {

//        self.userUID = UID
        
        if let user = userUID {
    
            self.ref_userDocument = db_base.collection("UID_UtenteBusiness").document(user)
    
        } else { self.ref_userDocument = nil }
    
    }
    
    func compilaCloudDataFromFirebase(handle: @escaping (_ :CloudDataStore?) -> () ) {
        
        let ref = ref_userDocument?.collection(CloudDataStore.CloudCollectionKey.dish.rawValue)
            
            ref?.getDocuments { queryDoc, error in
                
            guard error == nil, queryDoc?.documents != nil else {

                handle(nil)
                
                return }
                
            var cloudData:CloudDataStore = CloudDataStore()
                
            for doc in queryDoc!.documents {
               
                let dish = DishModel(id: doc.documentID)
                
                cloudData[keyPath: \.allMyDish].append(dish)
                
                    }
                
                handle(cloudData)
            
            }

    }
    
}



