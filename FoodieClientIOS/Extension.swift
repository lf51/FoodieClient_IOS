//
//  Protocol.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 18/12/22.
//

import Foundation
import MyFoodiePackage
import MyFilterPackage

extension DishModel:Object_FPC {

  //  public typealias VM = ClientVM
    
    public static func sortModelInstance(lhs: DishModel, rhs: DishModel, condition: SortCondition?, readOnlyVM: ClientVM) -> Bool {
        
        switch condition {
        
        case .mostRated:
            return lhs.rifReviews.count > rhs.rifReviews.count
        case .topRated:
            return lhs.topRatedValue(readOnlyVM: readOnlyVM) >
            rhs.topRatedValue(readOnlyVM: readOnlyVM)
        case .topPriced:
            return lhs.estrapolaPrezzoMandatoryMaggiore() >
            rhs.estrapolaPrezzoMandatoryMaggiore()
        default:
            return lhs.intestazione < rhs.intestazione

        }
    }
    
    public func stringResearch(string: String, readOnlyVM: ClientVM?) -> Bool {
        
       // guard string != "" else { return true }
        // First - Name
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let conditionOne = self.intestazione.lowercased().contains(ricerca)
        
        guard readOnlyVM != nil else { return conditionOne }
        // Second - Ingredients
        let allIngredients = self.allIngredientsAttivi(viewModel: readOnlyVM!)
        let allINGMapped = allIngredients.map({$0.intestazione.lowercased()})
        let allINGChecked = allINGMapped.filter({$0.contains(ricerca)})
        let conditionTwo = !allINGChecked.isEmpty
        //Third - Allergens
        let allINGbyAllergens = allIngredients.map({$0.allergeni}).joined()
        let allAllergens = allINGbyAllergens.map({$0.intestazione.lowercased()})
        let allergensChecked = allAllergens.filter({$0.contains(ricerca)})
        let conditionThird = !allergensChecked.isEmpty
        
        return conditionOne || conditionTwo || conditionThird
    }
    
   public func propertyCompare(coreFilter: CoreFilter<DishModel>, readOnlyVM: ClientVM) -> Bool {

        let filterProperties = coreFilter.filterProperties
       
        let allRIFCategories = filterProperties.categorieMenu?.map({$0.id})
        let allAllergeniIn = self.calcolaAllergeniNelPiatto(viewModel: readOnlyVM)
        let allDietAvaible = self.returnDietAvaible(viewModel: readOnlyVM).inDishTipologia
        let basePreparazione = self.calcolaBaseDellaPreparazione(readOnlyVM: readOnlyVM)
       
       let stringResult:Bool = {
           
           let stringa = coreFilter.stringaRicerca
           guard stringa != "" else { return true }
           
           let result = self.stringResearch(string: coreFilter.stringaRicerca, readOnlyVM: readOnlyVM)
           return coreFilter.tipologiaFiltro.normalizeBoolValue(value: result)
           
       }()
       
       let buildResult:Bool = {
           
           stringResult
           &&
           coreFilter.comparePropertyToCollection(
            localProperty: self.percorsoProdotto,
            filterCollection: filterProperties.percorsoPRP)
           &&
           coreFilter.compareRifToCollectionRif(
            localPropertyRif: self.categoriaMenu,
            filterCollection: allRIFCategories)
           &&
           coreFilter.compareCollectionToCollection(
            localCollection: allAllergeniIn,
            filterCollection: filterProperties.allergeniIn)
           &&
           coreFilter.compareCollectionToCollection(
            localCollection: allDietAvaible,
            filterCollection: filterProperties.dietePRP)
           &&
           coreFilter.comparePropertyToProperty(
            localProperty: basePreparazione,
            filterProperty: filterProperties.basePRP)
           &&
           self.preCallHasAllIngredientSameQuality(
            viewModel: readOnlyVM,
            kpQuality: \.produzione,
            quality: filterProperties.produzioneING)
           &&
           self.preCallHasAllIngredientSameQuality(
            viewModel: readOnlyVM,
            kpQuality: \.provenienza,
            quality: filterProperties.provenienzaING)
       }()
        
       return buildResult
       
    }
    
    
    public struct FilterProperty:SubFilterObject_FPC {
        
      // public typealias M = DishModel

     //  public var coreFilter:CoreFilter
     //  public var sortCondition: SortCondition
        
       var percorsoPRP:[DishModel.PercorsoProdotto]?
       var categorieMenu:[CategoriaMenu]?
       var basePRP:DishModel.BasePreparazione?
       var dietePRP:[TipoDieta]?
       var produzioneING:ProduzioneIngrediente?
       var provenienzaING: ProvenienzaIngrediente?
       var allergeniIn:[AllergeniIngrediente]?
        
       var showFavourites:Bool = false 
       
       public init() {
        //   self.coreFilter = CoreFilter()
        //   self.sortCondition = .defaultValue

       }
        
        public static func reportChange(old: DishModel.FilterProperty, new: DishModel.FilterProperty) -> Int {
            
            countManageSingle_FPC(
                newValue: new.basePRP,
                oldValue: old.basePRP)
            +
            countManageCollection_FPC(
                newValue: new.percorsoPRP,
                oldValue: old.percorsoPRP)
            +
            countManageCollection_FPC(
                newValue: new.categorieMenu,
                oldValue: old.categorieMenu)
            +
            countManageCollection_FPC(
                newValue: new.dietePRP,
                oldValue: old.dietePRP)
            +
            countManageSingle_FPC(
                newValue: new.produzioneING,
                oldValue: old.produzioneING)
            +
            countManageSingle_FPC(
                newValue: new.provenienzaING,
                oldValue: old.provenienzaING)
            +
            countManageCollection_FPC(
                newValue: new.allergeniIn,
                oldValue: old.allergeniIn)
        }

   }
    
    public enum SortCondition:SubSortObject_FPC {
        
       public static var defaultValue: SortCondition = .alfabeticoCrescente
        
        case topPriced
        case topRated
        case mostRated
        
        case alfabeticoCrescente
        
         public func simpleDescription() -> String {
            
             switch self {
                 
             case .topPriced: return "Prezzo"
             case .topRated: return "Media Voto"
             case .mostRated: return "Numero di Recensioni"
                 
             case .alfabeticoCrescente: return ""
                 
             }
         }
         
         public func imageAssociated() -> String {
             
             switch self {
                 
             case .topPriced: return "dollarsign"
             case .topRated: return "medal"
             case .mostRated: return "chart.line.uptrend.xyaxis"
                 
             case .alfabeticoCrescente: return ""
                 
             }
         }
         
     }
    
   
}

extension DishModel.PercorsoProdotto:Property_FPC {}

extension DishModel.BasePreparazione:Property_FPC {}

extension CategoriaMenu:Property_FPC_Mappable {}

extension TipoDieta:Property_FPC {}

extension ProduzioneIngrediente:Property_FPC {}

extension ProvenienzaIngrediente:Property_FPC {}

extension AllergeniIngrediente:Property_FPC {}

