//
//  DishRating_RowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/08/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import MyFilterPackage

/*

struct DishRatingListView: View {
    
  //  @ObservedObject var viewModel:FoodieViewModel
    
    let dishTitle: String
    let backgroundColorView: Color
    
    private let dishRating: [DishRatingModel]
    
    private let ratingsCount: Int
    private let mediaRating: Double
    private let mediaL10: Double

    @State private var minMaxRange: (Double,Double) = (0.0,10.0)
    
    init(dishItem:DishModel, backgroundColorView: Color, readOnlyViewModel:FoodieViewModel) {
        
      //  self.viewModel = readOnlyViewModel
        
        self.dishTitle = dishItem.intestazione
        self.backgroundColorView = backgroundColorView
        
        let(model,rif) = readOnlyViewModel.reviewFilteredByDish(idPiatto: dishItem.id)
        self.dishRating = model
        
        (self.ratingsCount,_,self.mediaRating,self.mediaL10) = readOnlyViewModel.monitorRecensioni(rifReview: rif)
        
        
    }
    
  //  @State var opac:CGFloat = 1.0
    @State private var frames:[CGRect] = []
    
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
                                
                                DishRating_RowView(
                                    rating: rate,
                                    backgroundColorView: backgroundColorView,
                                frames: $frames,
                                coordinateSpace: "RatingList")
                                    
                                
                            }
                            
                        }
                        
                    }
                }
                .cornerRadius(10)
               // .csCornerRadius(10, corners: [.topLeft,.topRight])
                .coordinateSpace(name: "RatingList")
                .onPreferenceChange(FramePreference.self, perform: {
                                frames = $0.sorted(by: { $0.minY < $1.minY })
                            })
                
                CSDivider()
            } // chiusa Vstack Madre
           // .padding(.horizontal)
            .background {
               // Color.red
                
            }
            
                
        }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text("+ Add")
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
                    
                    HStack(spacing:0) {
                        Text("L10")
                            .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                            .foregroundColor(.seaTurtle_2)
                        
                        vbMediaL10(mediaGen: mediaRating, mediaL10: mediaL10)
                    }
                    
                    Text("\(mediaL10,specifier: "%.1f")")
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


struct DishRating_RowView_Previews: PreviewProvider {
    
    static var ratings: [DishRatingModel] = [
        
    DishRatingModel(voto: "8.9", titolo: "Strepitoso", commento: "Materie Prime eccezzionali perfettamente combinate fra loro per un gusto autentico e genuino.", rifImage: "SampleV", idPiatto: "testDish"),
    DishRatingModel(voto: "4.0", titolo: "Il mare non c'è", commento: "Pesce congelato senza sapore",rifImage: "SampleH", idPiatto: "testDish"),
    DishRatingModel(voto: "6.5", titolo: "Il mare..forse", commento: "Pescato locale sicuramente di primissima qualità, cucinato forse un po' male.",rifImage: "SampleS",idPiatto: "testDish"),
    DishRatingModel(voto: "10.0", titolo: "Amazing", commento: "I saw the sea from the terrace and feel it in this amazing dish, with a true salty taste!! To eat again again again again for ever!!! I would like to be there again next summer hoping to find Marco and Graziella, two amazing host!! They provide us all kind of amenities, helping with baby food, gluten free, no Milk. No other place in Sicily gave to us such amazing help!!",idPiatto: "testDish")
    
    ]
    
    static let rate =  DishRatingModel(
        voto: "10.0",
        titolo: "Amazing",
        commento: "I saw the sea from the terrace and feel it in this amazing dish, with a true salty taste!! To eat again again again again for ever!!! I would like to be there again next summer hoping to find Marco and Graziella, two amazing host!! They provide us all kind of amenities, helping with baby food, gluten free, no Milk. No other place in Sicily gave to us such amazing help!!",
        rifImage: "DishSample",
        idPiatto: "testDish"
    )
    
    @State static var opac:CGFloat = 1.0
    @State static var frame:[CGRect] = []
    
    static var previews: some View {
        
        NavigationStack {
            DishRatingListView(dishItem: dishItem3_Test, backgroundColorView: .seaTurtle_1, readOnlyViewModel: testAccount)
        }
        
      /* CSZStackVB(
            title: "TestDish",
            titlePosition: .bodyEmbed([.horizontal,.top],10),
            backgroundColorView: .seaTurtle_1) {
        
        VStack {
            CSDivider()
            
         Text("Opacità Massima")
                .opacity(opac)
            
            ScrollView(showsIndicators:false) {
                
              /*  Image("SampleV")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                
                Image("SampleH")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                
                Image("SampleS")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .onHover { value in
                        opac = 0.0
                    }
                    .onTapGesture {
                        opac = 0.0
                    } */
                
                
                ForEach(ratings) { rate in
                    
                    DishRating_RowView(
                        rating: rate,
                        backgroundColorView: .seaTurtle_1,
                        frames: $frame,
                        coordinateSpace: "Test")
                }
                
                
            }
            .coordinateSpace(name: "Test")
            .onPreferenceChange(FramePreference.self, perform: {
                            frame = $0.sorted(by: { $0.minY < $1.minY })
                        })
            CSDivider()
            
        }
        
    } */
       
    }
}

*/ // 08.02.23 Ricollocata in MyFoodiePackage

/*

struct DishRating_RowView: View {
    
    let rating: DishRatingModel
    let frameWidth: CGFloat
    let backgroundColorView:Color
    let backgroundOpacity:CGFloat
    // 25.01 cercando un gesto
    @Binding var frames:[CGRect]
    let coordinateSpace:String
    
    init(
        rating: DishRatingModel,
        frameWidth: CGFloat = 650,
        riduzioneMainBounds:CGFloat = 20,
        backgroundColorView:Color,
        backgroundOpacity:CGFloat = 0.6,
        frames:Binding<[CGRect]>,
        coordinateSpace:String) {
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width - riduzioneMainBounds
        
        self.rating = rating
        self.frameWidth = .minimum(frameWidth, screenWidth)
        self.backgroundColorView = backgroundColorView
        self.backgroundOpacity = backgroundOpacity
        _frames = frames
        self.coordinateSpace = coordinateSpace
    }
    
    var body: some View {
        
        VStack(alignment:.leading,spacing: 0) {
            
            HStack {
                
                Text(rating.voto)
                       // .font(.largeTitle)
                    .font(.system(size: frameWidth * 0.12))
                    .fontWeight(.black)
                   // .foregroundColor(.seaTurtle_4)
                
                    .padding(.horizontal,5)
                    .background(
                       // Color.green
                        rating.rateColor()
                            .csCornerRadius(10, corners: [.topLeft])
                            .opacity(0.7)
                            //.cornerRadius(10.0)
                            
                    )
 
                Text(rating.titolo)
                   // .font(.system(.largeTitle, design: .serif, weight: .semibold))
                    .font(.system(size: frameWidth * 0.1,weight: .black,design: .serif))
                  //  .foregroundColor(.seaTurtle_4)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Spacer()
                
            }
            .foregroundColor(.seaTurtle_4)
            
         //  .padding(.vertical,10)
            .padding(.trailing,5)
        //   .padding(.bottom,10)
            .background {
               Color.seaTurtle_1
                   //.cornerRadius(10)
                   .csCornerRadius(10, corners: [.topRight,.topLeft])
                   .opacity(0.4)
           }
           .sticky(frames, coordinateSpace: coordinateSpace)
           .padding(.bottom,10)
            
            
            VStack(spacing:10) {
                
                Image(rating.rifImage)
                   
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .background {
                     //   Color.brown
                    }
                

                Text(rating.commento)
                    .font(.system(size:frameWidth * 0.05, weight: .light,design: .serif))
                    .foregroundColor(.black)
                    .opacity(0.8)
                   //.multilineTextAlignment(.center)
                    .background {
                       // Color.orange
                    }
            }
          //  .padding(.bottom,10)
            
            VStack(alignment:.center,spacing:10) {
                
                HStack(spacing:4) {
                    
                    Spacer()
                    Text( csTimeFormatter().data.string(from: Date()) )
                    Text( csTimeFormatter().ora.string(from: Date()) )
                    Text("- user anonimo")
                    
                }
                .italic()
                .font(.system(.caption, design: .serif, weight: .ultraLight))
                .foregroundColor(Color.black)
               // .padding(.bottom,5)
                .background {
                   // Color.white
                }

               /* HStack {
                    
                    Text(Image(systemName:"hand.thumbsup"))
                        .font(.system(size: frameWidth * 0.08))
                    Text("1.4k")
                        .bold()
                  
                }
                .padding(.horizontal,10)
                .padding(.vertical,5)
                .background {
                    Color.blue.cornerRadius(15)
                } */ // 30.01 Upgrade Futuro
                
                
            }
            .padding(.horizontal,5)
            .padding(.vertical,10)
         
            
            
        } // chiusa ZStack
        
      //  .padding(.horizontal,10)
        .background(
            backgroundColorView
          //  .cornerRadius(10)
                .csCornerRadius(10, corners: [.topLeft,.topRight])
            .opacity(backgroundOpacity)
           // .shadow(color: .gray, radius: 1, x: 0, y: 1)
        )
        
        
        
        
        
      /*  ZStack(alignment:.leading) {
            
            Image(rating.rifImage)
                .resizable()
                .scaledToFit()
                .cornerRadius(15)
                .zIndex(test)
            
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
                            .opacity(test)
                            .gesture(testGesture)
                        // limitare il numero di righe // caratteri
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
            .zIndex(1)
            
            
        }
        .frame(width:frameWidth)
        
*/
    }
} */
//08.02.23 Ricollocata in MyFoodiePackage
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



