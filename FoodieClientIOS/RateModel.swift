//
//  RateModel.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 01/02/23.
//

import Foundation
import MyFoodiePackage
import SwiftUI

public struct ReviewModel {
    // Da spostare nel FoodiePackage per sostituire il vecchio DishRatingModel
    public var id: String
    public let rifPiatto: String
    
    public var titolo: String?
    public var commento: String?
    public var rifImage: String? // sarà uguale all'id del reviewModel
    
    public var voto: RateModel
    public let dataRilascio: Date

    public init(rifDish:String,percorsoProdotto:DishModel.PercorsoProdotto) {
        
        self.id = UUID().uuidString
        self.rifPiatto = rifDish

        self.voto = RateModel(percorsoProdotto: percorsoProdotto)
        self.dataRilascio = Date()
        
        
    }
    
    public func rateColor() -> Color {
        
       // guard let vote = Double(self.voto) else { return Color.gray }
        let vote = self.voto.generale
      
        if vote <= 6.0 { return Color.red }
        else if vote <= 8.0 { return Color.orange }
        else if vote <= 9.0 { return Color.yellow }
        else { return Color.green }
        
    }
    
    public func isVoteInRange(min:Double,max:Double) -> Bool {
        
     //  guard let vote = Double(self.voto) else { return false }
        let vote = self.voto.generale
            
        return vote >= min && vote <= max
        
    }

    /// tiriamo fuori un voto e peso (il peso va da 0.1 a 1.05)
    public func pesoRecensione() -> Double {

      //  let theVote = self.voto.generale
        
        // Peso va da 0.01 a 1.00 // Andremo oltre 1.0 grazie alla reputazione dell'utente. Upgrade futuro.
        var completingRate:Double = 0.25
        
        // voto
        // titolo
        // descrizione
        // image
        // Tot: 1.0
                
        if self.titolo != nil { completingRate += 0.15 }
        else { completingRate -= 0.05 }
        
        if let commento = self.commento {
            
            let countChar = commento.replacingOccurrences(of: " ", with: "").count
            
            if countChar < 70 { completingRate += 0.2 }
            else { completingRate += 0.3 }
            
          /*  else if countChar > 70,
                    countChar <= 220 {
                completingRate += 0.3
            } // gold range
            
            else if countChar > 220 { completingRate += 0.25 } */
            
        }
        else { completingRate -= 0.095 }
        
        if self.rifImage != nil { completingRate += 0.3 }
        else { completingRate -= 0.095}


        return completingRate
    }
    
    
    
    
}

public struct RateModel {
    // da sistemare in chiave salvataggio su firebase. Non serve salvare i pesi che sono praticamente due set(uno per food, uno per drink) uguali per tutte le recensioni
    public var presentazione:Double
    public var cottura:Double
    public var mpQuality:Double
    public var succulenza:Double
    public var gusto:Double

    let pesoPresentazione:Double
    let pesoCottura:Double
    let pesoMpQuality:Double
    let pesoSucculenza:Double
    let pesoGusto:Double
    
    var sommaPesi:Double {
        pesoPresentazione +
        pesoCottura +
        pesoMpQuality +
        pesoSucculenza +
        pesoGusto
    } // la vogliamo sempre uguale a 10
        
    public var generale:Double {
        
        get {
            
           ((presentazione * pesoPresentazione) +
            (cottura * pesoCottura) +
            (mpQuality * pesoMpQuality) +
            (succulenza * pesoSucculenza) +
            (gusto * pesoGusto)) / sommaPesi
            
        }
        
        set {
            
            presentazione = newValue
            cottura = newValue
            mpQuality = newValue
            succulenza = newValue
            gusto = newValue
        }
    }
    
    public init(percorsoProdotto:DishModel.PercorsoProdotto) {
        
        switch percorsoProdotto {

        case .preparazioneFood:
            
            pesoPresentazione = 1
            pesoCottura = 1
            pesoMpQuality = 3
            pesoSucculenza = 2.5
            pesoGusto = 2.5
            
        default:
            
            pesoPresentazione = 1.5
            pesoCottura = 0.0
            pesoMpQuality = 3.0
            pesoSucculenza = 2.75
            pesoGusto = 2.75
        }
        
        self.presentazione = 10.0
        self.cottura = 10.0
        self.mpQuality = 10.0
        self.succulenza = 10.0
        self.gusto = 10.0
        
    }
    
   
}
