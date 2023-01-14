//
//  DishRating_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/08/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage


struct DishRatingListView: View {
    
    let dishTitle: String
    let backgroundColorView: Color
    
    private let dishRating: [DishRatingModel]
    private let ratingsCount: Int
    private let mediaRating: Double

    @State private var minMaxRange: (Double,Double) = (0.0,10.0)
    
    init(dishItem:DishModel, backgroundColorView: Color, readOnlyViewModel:FoodieViewModel) {
        
        self.dishTitle = dishItem.intestazione

        (self.mediaRating,self.ratingsCount,self.dishRating) = dishItem.ratingInfo(readOnlyViewModel: readOnlyViewModel)
        self.backgroundColorView = backgroundColorView
    }
    
    var body: some View {
       
        CSZStackVB(
            title: dishTitle,
            titlePosition: .bodyEmbed([.horizontal,.top],10),
            backgroundColorView: backgroundColorView) {
        
            VStack {
                                
                HStack(alignment:.top) {
                    
                    csSplitRatingByVote()
                        .font(.system(.subheadline, design: .rounded, weight: .light))
                    
                   Spacer()
                    
                    vbRatingvote()
                    
                    
                }
                .background {
                  //  Color.green
                }
           
             //   CSDivider()
                
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        
                        ForEach(dishRating,id:\.self) { rate in
                            // da ordinare seguendo la data
                            if rate.isVoteInRange(min: minMaxRange.0, max: minMaxRange.1) {
                                DishRating_RowView(rating: rate) }
                            
                        }
                        
                    }
                }
            
                
                CSDivider()
            } // chiusa Vstack Madre
           // .padding(.horizontal)
            .background {
               // Color.red
                
            }
            
                
        }
            
    }
    
    // method
    
    @ViewBuilder private func vbRatingvote() -> some View {
  
        HStack(alignment:.top) {
                
                   Text("\(mediaRating,specifier: "%.1f")")
                        .fontWeight(.black)
                        .font(.largeTitle)
                        .foregroundColor(.seaTurtle_1)
                        .padding(5)
                        .background {
                            Color.seaTurtle_2.cornerRadius(5.0)
                        }
                
                VStack(spacing:-5) {
                    
                    Text("L10")
                        .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                        .foregroundColor(.seaTurtle_2)
                    
                    Text("\(mediaRating,specifier: "%.1f")")
                        .fontWeight(.heavy)
                        .font(.title)
                        .foregroundColor(.seaTurtle_4)
                    }
                    .padding(.horizontal,5)
                    .background {
                        Color.seaTurtle_1.cornerRadius(5.0)
                    }
            }
        .background{
          //  Color.gray
            
        }

    }
    
    private func csSplitRatingByVote() -> some View {
        
        let fromZeroToSix = "da 0 a 5.99"
        let fromSixTo8 = "da 6 a 7.99"
       // let from8To9 = "da 8.1 a 9"
        let from9To10 = "da 8 a 10"
        
        var ratingContainer: [String:Int] = [fromZeroToSix:0,fromSixTo8:0,from9To10:0]
        let ratingRangeValue: [String:(Double,Double)] = [fromZeroToSix:(0.0,5.99),fromSixTo8:(6.0,7.99),from9To10:(8.0,10.0)]
        
        for rating in self.dishRating {
            
            guard let vote = Double(rating.voto) else { continue }
            
            if vote < 6.0 { ratingContainer[fromZeroToSix]! += 1 }
            else if vote < 8.0 { ratingContainer[fromSixTo8]! += 1 }
            else { ratingContainer[from9To10]! += 1 }
        }

        return Grid(alignment:.leading,verticalSpacing: 5) {
            
            ForEach(ratingContainer.sorted(by: <), id: \.key) { key, value in
                
                let isTheRangeActive = self.minMaxRange == ratingRangeValue[key]!
                
                GridRow {
                    
                    Text(key)
                       // .fontWidth(.condensed)
                        .foregroundColor(Color.black)
                    
                    Text("( \(value,format: .number.notation(.compactName)) )")
                        .fontWeight(.semibold)
                        .foregroundColor(.seaTurtle_4)
                    
                    Button {
                        withAnimation {
                            self.minMaxRange = isTheRangeActive ? (0.0,10.0) : ratingRangeValue[key]!
                        }
                    } label: {
                        Image(systemName: isTheRangeActive ? "eye" : "eye.slash")
                            .imageScale(.medium)
                            .foregroundColor(.seaTurtle_3)
                            .opacity(isTheRangeActive ? 1.0 : 0.6)
                    }
                    
                } // GridRow
                
            } // chiusa ForEach
        
            GridRow {
                
                Text("totale:")
                    .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                    .fontWidth(.compressed)
                    .gridCellColumns(1)
                Text("\(ratingsCount,format: .number.notation(.automatic))")
                    .fontWeight(.black)
                    .font(.subheadline)
                    .gridCellColumns(2)
            }
            
        } // Chiusa Grid

        
    }
    
   
    
}

struct DishRating_RowView: View {
    
    let rating: DishRatingModel
    
    var body: some View {
        
        CSZStackVB_Framed(riduzioneMainBounds:20) {
            
            VStack(alignment:.leading) {
                
                HStack {
                    
                    Text(rating.voto)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.seaTurtle_4)
                        .padding(.horizontal,5)
                        .background(rating.rateColor().cornerRadius(5.0))
   
                    Text(rating.titolo)
                        .font(.system(.largeTitle, design: .serif, weight: .semibold))
                        .foregroundColor(.seaTurtle_3)
                        .lineLimit(1)
                    
                }
               .padding(.vertical)
           
                
                ScrollView {
                    
                    VStack {
                        
                        Text(rating.commento)
                            .font(.system(.body, design: .serif, weight: .light))
                            .foregroundColor(.seaTurtle_4)
                        
                    }
                    
                    
                }
 
                Spacer()
                
                HStack {
                    Spacer()
                    Text( csTimeFormatter().data.string(from: rating.dataRilascio) )
                    Text( csTimeFormatter().ora.string(from: rating.dataRilascio) )
                    
                }
                .italic()
                .font(.system(.caption, design: .serif, weight: .ultraLight))
                .foregroundColor(Color.black)
                .padding(.bottom,5)
                
            }
            .padding(.horizontal,10)
            .background(Color.black.opacity(0.1))
            ._tightPadding()
            
            
        }
    }
}
/*
struct DishRating_RowView: View {
    
    let rating: DishRatingModel
    
    var body: some View {
        
        CSZStackVB_Framed(riduzioneMainBounds:20) {
            
            VStack(alignment:.leading) {
                
                HStack {
                    
                    Text(rating.voto)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.seaTurtle_4)
                        .padding(.horizontal,5)
                        .background(rating.rateColor().cornerRadius(5.0))
   
                    Text(rating.titolo)
                        .font(.system(.largeTitle, design: .serif, weight: .semibold))
                        .foregroundColor(.seaTurtle_3)
                        .lineLimit(1)
                    
                }
               .padding(.vertical)
           
                
                ScrollView {
                    
                    VStack {
                        
                        Text(rating.commento)
                            .font(.system(.body, design: .serif, weight: .light))
                            .foregroundColor(.seaTurtle_4)
                        
                    }
                    
                    
                }
 
                Spacer()
                
                HStack {
                    Spacer()
                    Text( csTimeFormatter().data.string(from: rating.dataRilascio) )
                    Text( csTimeFormatter().ora.string(from: rating.dataRilascio) )
                    
                }
                .italic()
                .font(.system(.caption, design: .serif, weight: .ultraLight))
                .foregroundColor(Color.black)
                .padding(.bottom,5)
                
            }
            .padding(.horizontal,10)
            .background(Color.black.opacity(0.1))
            ._tightPadding()
            
            
        }
    }
} */ // 13.01.23 Backup per upgrade



