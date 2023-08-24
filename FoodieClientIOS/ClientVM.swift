//
//  ClientVM.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 08/12/22.
//

import Foundation
import SwiftUI
import MyFoodiePackage
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import MyFilterPackage

extension CloudDataStore:Codable {
    
    public enum SubSetupKeys:String,CodingKey {
        
        case startCountDownMenuAt
 
    }
    
    
    public init(from decoder: Decoder) throws {
        
         self.init() // 17.12.22 credo sia necessario perchè il cloudDataStore è optional
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // 0.step
        self.allMyProperties = try values.decode([PropertyModel].self, forKey: .allMyProperties)
        
        // 1.step
        let privateMenu = try values.decode([MenuModel].self, forKey: .allMyMenu)/*.filter({$0.isOnAir()}) 10.01.23 oscurato per Test. Da ripristinare */
        self.allMyMenu = privateMenu
        let allRif_dish = privateMenu.flatMap({$0.rifDishIn})
    
        // 2.step
        
        let privateDish = try values.decode([DishModel].self, forKey: .allMyDish).filter({
            allRif_dish.contains($0.id) &&
            $0.status.checkStatusTransition(check: .disponibile)
        })
        
        let allRif_categoria = privateDish.compactMap({$0.categoriaMenu})
        self.allMyDish = privateDish
        // manca nel pacchetto una funzionalità per ritornare tutti gli id ingrediente collegati al piatto. Quando faremo ordine nei metodi la dobbiamo usare anche qui per scaricare solo gli ing in uso nei piatti in menu
        
        // 3.step
        self.allMyIngredients = try values.decode([IngredientModel].self, forKey: .allMyIngredients).filter({
            !$0.status.checkStatusTransition(check: .archiviato)
        })
      
        // 4.step
        self.allMyCategories = try values.decode([CategoriaMenu].self, forKey: .allMyCategories).filter({
            allRif_categoria.contains($0.id)
        })
  
        // 5.step
        self.allMyReviews = try values.decode([DishRatingModel].self, forKey: .allMyReviews).filter({
            allRif_dish.contains($0.rifPiatto)
        })
        
        // 6.step
        let secondLevel = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .otherDocument)
        let deepLevel = try secondLevel.nestedContainer(keyedBy: SubSetupKeys.self, forKey: .setupAccount)
        
        self.setupAccount.startCountDownMenuAt = try deepLevel.decode(AccountSetup.TimeValue.self, forKey:.startCountDownMenuAt)
        
        
     }
    
    public func encode(to encoder: Encoder) throws {
        
        // codifica solo le review
        
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
        
      //Gli errori sembrerebbero essere dovuti ad un update mancante, o forse alle versioni deployed. Il codice è copiato dalla documentazione firebase, a parte il guard. E' un errore del compilatore che comunque non influisce sul funzionamento.
      //  ref_userDocument.d
        guard let docRef = ref_userDocument else {
            handle(nil)
            return
        }
        
        docRef.getDocument(as: CloudDataStore.self) { (result) in
        
            switch result {
                
            case .success(let cloudData):
                handle(cloudData)
                print("CloudDataStore caricato con successo da Firebase")
            case .failure(let error):
                handle(nil)
                print("Download from Firebase FAIL: \(error)")
            }
            
            
            
        }
        
        
        /* let ref = ref_userDocument?.collection(CloudDataStore.CloudCollectionKey.dish.rawValue)
            
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
            
            } */

    }
    
} // end Struct

public final class ClientVM: FoodieViewModel {
    
  //  public var allMyIngredients: [IngredientModel] = []
  //  public var allMyDish: [DishModel] = []
  //  public var allMyMenu: [MenuModel] = []
  //  public var allMyProperties: [PropertyModel] = []
  //  public var allMyCategories: [CategoriaMenu] = []
  //  public var allMyReviews: [DishRatingModel] = []
    
    // 12.12.22 Non usiamo direttamente gli array sopra ma usiamo un dataCloud. Dovremmo trasformare in tal senso anche Foodie Business. Step by Step
    
  //  @Published var cloudData: CloudDataStore?
    var cloudDataCompiler:CloudDataCompiler?
    
   public var checkInProperties:[PropertyModel] = []
    
    @Published var preSelectionRif:[String] = [] // rif dei piatti selezionati
    @Published var menuPath = NavigationPath()
    
    init() {
        super.init()
        // 1. Caricare dati salvati sullo userDefault. Dati sintetici in stringa per ricostruire data del check-in, luogo, città, ed eventuale recensione. Costruire un dictionary
        
    }
    
    func salvareDataOnUserDefault(cloudData:CloudDataStore?) {
        
        // salva le proprietà visitate sullo userDefault, e anche l'elenco dei piatti ma per 48/72 ore
        
        guard let data = cloudData,
              data.allMyProperties.count < 2
        else {
            print("CloudData equal to Nil or properties are more than one")
            return }
        
        print("Scrivere Logica per salvare i dati su UserDefault")
      //  let userDef = UserDefaults.standard
        
        
        
       // UserDefaults.standard.
        
        
    }
    
    
    func commpilaCloudDataFromUserDefault() {
        
        // Crea una istanza di CloudDataStore con i dati salvati localmente sul device
       // UserDefaults.standard.dictionaryRepresentation()
    }
    
    func compilaCloudDataFromFirebase() {
        
        guard let compiler = self.cloudDataCompiler else { return }
        
        compiler.compilaCloudDataFromFirebase { cloudData in
            
            self.checkInProperties.append(contentsOf: cloudData?.allMyProperties ?? [])
            self.allMyDish.append(contentsOf: cloudData?.allMyDish ?? [])
            self.allMyIngredients.append(contentsOf: cloudData?.allMyIngredients ?? [])
            self.allMyReviews.append(contentsOf: cloudData?.allMyReviews ?? [])
            self.allMyCategories.append(contentsOf: cloudData?.allMyCategories ?? [])
            
          // self.cloudData = cloudData // fa aggiornare una published
           
            self.salvareDataOnUserDefault(cloudData: cloudData)
           
            print("is allMyDish empty:\(self.allMyDish.isEmpty.description)")
        }
        
        print("ClientVM/compilaCloudDataFromFirebase")
        
    }
    
    /// <#Description#>
    /// - Parameter rif: id del piatto
    /// - Returns: <#description#>
    func checkSelection(rif:String) -> Bool {
        
        let value = self.preSelectionRif.contains(rif)
        print("[0] CheckSelection: Value is \(rif) -> Return is \(value.description)")
        return value
    }
    
    /// Metodo per aggiungere e riuovere i piatti selezionati. Messo nel viewmodel perchè condiviso da più view
    /// - Parameter rif: id del piatto
    func preSelectionLogic(rif:String) {
        
        var dishes = self.preSelectionRif
        
        if let index = dishes.firstIndex(of: rif) {
            
            dishes.remove(at: index)
            
        } else {
            
            dishes.append(rif)
        }
        
        self.preSelectionRif = dishes
                
        print("[1] preSelectionLogic: Value is -> \(rif)")

    }
}

extension ClientVM: VM_FPC {
     
    public func ricercaFiltra<M:Object_FPC>(
        containerPath: WritableKeyPath<ClientVM, [M]>,
        coreFilter: CoreFilter<M>) -> [M] where ClientVM == M.VM {
            
            // Step_0 Vediamo se ci sono piatti Preferiti

            let container:[M] = {
                // Nota 24.01.23 CoreFilter<DishModel>
                guard let filterCore = coreFilter as? CoreFilter<DishModel>,
                      filterCore.filterProperties.showFavourites else {
                    
                    return self[keyPath: containerPath]
                }
                
                let favourites:[M] = self.modelCollectionFromCollectionID(collectionId: self.preSelectionRif, modelPath: \.allMyDish) as? [M] ?? []
              
                return favourites
                
            }()
            
            
           // let container = self[keyPath: containerPath]
            
            let containerFiltered = container.filter({ $0.propertyCompare(coreFilter: coreFilter, readOnlyVM: self) })
            
            let containerSorted = containerFiltered.sorted {
                M.sortModelInstance(lhs: $0, rhs: $1, condition: coreFilter.sortConditions, readOnlyVM: self)
            }
            return containerSorted
    }
    
}


    

