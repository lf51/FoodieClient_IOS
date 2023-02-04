//
//  TESTRatingRow.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 26/01/23.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct TESTRatingRow: View {
    
    let commento:String = "I saw the sea from the terrace and feel it in this amazing dish, with a true salty taste!! To eat again again again again for ever!!! I would like to be there again next summer hoping to find Marco and Graziella, two amazing host!! They provide us all kind of amenities, helping with baby food, gluten free, no Milk. No other place in Sicily gave to us such amazing help!!"
    let screenWidth: CGFloat = UIScreen.main.bounds.width - 20
    var frameWidth: CGFloat {
        
        .minimum(650, screenWidth)
    }
    
    let image:String
    
    
    var body: some View {
        
        VStack(alignment:.leading,spacing: 0) {
            
            HStack {
                
                Text("8.5")
                   // .font(.largeTitle)
                    .font(.system(size: frameWidth * 0.12))
                    .fontWeight(.black)
                    .foregroundColor(.seaTurtle_4)
                    .padding(.horizontal,5)
                    
                    .background(
                        Color.green.cornerRadius(10.0)
                            
                    )
                    

                Text("Amazing Execution")
                   // .font(.system(.largeTitle, design: .serif, weight: .semibold))
                    .font(.system(size: frameWidth * 0.1,weight: .black,design: .serif))
                    .foregroundColor(.seaTurtle_4)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
            }.background {
              //  Color.red
            }
           .padding(.vertical,10)
           .padding(.trailing,5)
            
            VStack(spacing:10) {
                
                Image(image)
                   
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .background {
                     //   Color.brown
                    }
                

                Text(commento)
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

                HStack {
                    
                    Text(Image(systemName:"hand.thumbsup"))
                        .font(.system(size: frameWidth * 0.08))
                    Text("1.4k")
                        .bold()
                  
                }
                .padding(.horizontal,10)
                .padding(.vertical,5)
                .background {
                    Color.blue.cornerRadius(15)
                }
                
                
            }
            .padding(.horizontal,5)
            .padding(.vertical,10)
         
            
            
        } // chiusa ZStack
        
      //  .padding(.horizontal,10)
        .background(
            Color.seaTurtle_1
            .cornerRadius(15)
            .opacity(0.4))
        
        
        
      //  .frame(width:frameWidth)
     
     // .frame(height:frameWidth * 1.33)
        
        
    }
}

struct TESTRatingRow_Previews: PreviewProvider {
    static var previews: some View {
        
        CSZStackVB(
            title:"dishTitle",
            titlePosition: .bodyEmbed([.horizontal,.top],10),
            backgroundColorView: .seaTurtle_1) {
            ScrollView(.vertical,showsIndicators: false) {
                
                VStack {
                    
                    TESTRatingRow(image: "SampleS")
                    TESTRatingRow(image: "SampleV")
                    TESTRatingRow(image: "SampleH")
              
                    
                }
            }
        }
        
    }
}
