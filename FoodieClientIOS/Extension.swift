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
        
       return true
    }
    
    public func stringResearch(string: String, readOnlyVM: ClientVM?) -> Bool {
        
        guard string != "" else { return true }
        
        let ricerca = string.replacingOccurrences(of: " ", with: "").lowercased()
        let conditionOne = self.intestazione.lowercased().contains(ricerca)
        
        return conditionOne
    }
    
    public func propertyCompare(filterProperties: FilterProperty, readOnlyVM: ClientVM) -> Bool {
          
        let coreFilter = filterProperties.coreFilter
        let allRIFCategories = filterProperties.categorieMenu?.map({$0.id})
        
         return self.stringResearch(string: coreFilter.stringaRicerca, readOnlyVM: readOnlyVM) &&
        
          coreFilter.comparePropertyToCollection(localProperty: self.percorsoProdotto, filterCollection: filterProperties.percorsoPRP) &&
        
          coreFilter.compareRifToCollectionRif(localPropertyRif: self.categoriaMenu, filterCollection: allRIFCategories)
        
        
      }
    
    public struct FilterProperty:SubFilterObject_FPC {
        
       public typealias M = DishModel

       public var coreFilter:CoreFilter
       public var sortCondition: SortCondition
        
       var percorsoPRP:[DishModel.PercorsoProdotto]?
       var categorieMenu:[CategoriaMenu]?
       var basePRP:DishModel.BasePreparazione?
       var dietePRP:[TipoDieta]?
       
       public init() {
           self.coreFilter = CoreFilter()
           self.sortCondition = .defaultValue

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

extension CategoriaMenu:Property_FPC {}

extension TipoDieta:Property_FPC {}

