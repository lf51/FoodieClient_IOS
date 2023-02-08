//
//  ModuloRecensione.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 30/01/23.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import MyFilterPackage

enum PickerSourceType:Identifiable {
    
    var id: String { self.caseId() }
    case library,camera
    
    func caseId() -> String {
        switch self {
        case .library:
            return "library"
        case .camera:
            return "camera"
        }
    }
}

struct ModuloRecensione: View {

    @State private var newReview:ReviewModel
    let dishName:String
    let backgroundColorView:Color
    
    init(rifDish:String,dishName:String,percorsoDish:DishModel.PercorsoProdotto,backgroundColorView:Color) {
        
        let newRev = ReviewModel(rifDish: rifDish, percorsoProdotto: percorsoDish)
        _newReview = State(wrappedValue: newRev)
        self.dishName = dishName
        self.backgroundColorView = backgroundColorView
    }
    
    @State private var titolo:String = ""
    @State private var commento:String = ""
    @State private var pickedImage:UIImage?
    
    @State private var openDescription:Bool? // ??
    @State private var pickerSource:PickerSourceType?
   
  //  @State private var showSheet:Bool = false
    
    var body: some View {
        
        CSZStackVB(
            title: self.dishName,
            backgroundColorView: backgroundColorView) {
        
                VStack(alignment:.leading,spacing: 5) {
                    
                    CSDivider()
                    
                    ScrollView(showsIndicators:false) {
                          
                        VStack(spacing:10) {
                           
                            vbTitolo()
                            vbCommento()
                           // vbPicPick()
                            CSPickerImageView(
                                pickedImage: $pickedImage,
                                pickerSource: $pickerSource)
                            
                            vbRate()
                            
                            SaveButton(
                                review: $newReview) {
                                    vbReviewDescription()
                            
                                } checkPreliminare: {
                                    true
                                }
                            
                        }
                    }
 
                   CSDivider()
                    
                    

                    
                }
                .padding(.horizontal)
  
            }
            .popover(item:$pickerSource) { source in
                
                switch source {
                    
                case .library:
                    CSImagePicker(image: $pickedImage)
                        .presentationDetents([.large])
                case .camera:
                    CSPickerImage_CAM(selectedImage: $pickedImage)
                        .presentationDetents([.height(600)])
                    
                }
            }
            .onChange(of: self.pickedImage) { newValue in
                
                self.newReview.rifImage = newValue == nil ? nil : self.newReview.id
                
            }

    }
    
    // ViewBuilder
    
    @ViewBuilder private func vbReviewDescription() -> Text {
        
        let titleString:String? = self.newReview.titolo == nil ? "\n• Dai un titolo" : nil
        
        let descrString:String? = {
           
            if let description = self.newReview.commento {
                
                if description.count < ReviewModel.minLenghtComment { return "\n• Articola con più parole il commento "}
                else { return nil }
                
            } else {
                return "\n• Scrivi un commento"
            }
            
        }()
        
        let imageString:String? = self.newReview.rifImage == nil ? "\n• Carica una foto" : nil
        
        let optionalString:String? = {
            
            guard titleString == nil,
                  descrString == nil,
                  imageString == nil else {
                
                return "\nPer aumentare il valore della tua recensione:\(titleString ?? "")\(descrString ?? "")\(imageString ?? "")"
            }
            
           return nil
        }()
        
        
        let peso = self.newReview.pesoRecensione()

        Text("La tua recensione avrà un peso pari a: \(peso,specifier: "%.2f")") +
        Text(optionalString ?? "\nOttimo!!")
        
        
        
    }
    
    
    @ViewBuilder private func vbPicPick() -> some View {
        
        VStack(alignment:.leading,spacing:5.0) {
            
            CSLabel_conVB(
                placeHolder: "Immagine",
                imageNameOrEmojy: "photo",
                backgroundColor: .seaTurtle_4) {
                    Image(systemName: "plus")
                    
                }

            Image("SampleV")
                .resizable()
                .scaledToFit()
                .cornerRadius(5.0)

            
        }
    }
    
    @ViewBuilder private func vbRate() -> some View {
        
        let step = 0.1
        let range = 0...10.0
        
        VStack(alignment:.leading,spacing: 5.0) {
            
            CSLabel_conVB(
                placeHolder: "Voto",
                imageNameOrEmojy: "medal",
                backgroundColor: .seaTurtle_4) {

                    Stepper(value: self.$newReview.voto.generale, in: range,step:step) {
                            
                    Slider(value: self.$newReview.voto.generale, in: range,step: step)
                            
                        }
                }
            
            CSZStackVB_Framed(
               
                backgroundOpacity: 0.8,
                shadowColor: .clear,
                rowColor: .seaTurtle_1) {
                    
                HStack {
                    
                    Spacer()
                    
                    Text("\(self.newReview.voto.generale,specifier: "%.1f")")
                        .font(.system(size: 100))
                        .fontWeight(.black)
                        .foregroundColor(.seaTurtle_4)
                    
                    Spacer()

                }
                   
            }

                VStack(alignment:.leading,spacing: 5) {

                    VStack(alignment:.leading,spacing:0) {
                        
                        Stepper(
                            value: self.$newReview.voto.presentazione,
                            in: range,
                            step: step) {
                                vbStepperLabel(placeHolder: "Presentazione", specificValue: self.newReview.voto.presentazione)
                        }
                            
                            Text("Valuta aspetto disposizione e colori, di vivanda e servizio")
                                .italic()
                                .fontWeight(.light)
                                .font(.caption)
                                .foregroundColor(.black)
                                .opacity(0.8)
                    }
                        
                        Divider()
                        
                    Stepper(
                        value: self.$newReview.voto.cottura,
                        in: range,
                        step: step) {
                            vbStepperLabel(placeHolder: "Punto di cottura", specificValue: self.newReview.voto.cottura)
                    }

                        
                        Divider()
                        
                    Stepper(
                        value: self.$newReview.voto.mpQuality,
                        in: range,
                        step: step) {
                            vbStepperLabel(placeHolder: "Qualità ingredienti", specificValue: self.newReview.voto.mpQuality)
                    }
                    
                        Divider()
               
                    VStack(alignment:.leading,spacing:0) {
                                
                                Stepper(
                                    value: self.$newReview.voto.succulenza,
                                    in: range,
                                    step: step) {
                                        vbStepperLabel(placeHolder: "Succulenza", specificValue: self.newReview.voto.succulenza)
                                }
                                
                                    Text("Valuta la quantità e l'equilibrio degli ingredienti")
                                        .italic()
                                        .fontWeight(.light)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                        .opacity(0.8)
                            }
                 
                            Divider()
                            
                    VStack(alignment:.leading,spacing: 0) {
                                
                                Stepper(
                                    value: self.$newReview.voto.gusto,
                                    in: range,
                                    step: step) {
                                        vbStepperLabel(placeHolder: "Gustosità", specificValue: self.newReview.voto.gusto)
                                    }
                                
                                    Text("Valuta l'armonia, l'intensità e la gradevolezza dei sapori")
                                        .italic()
                                        .fontWeight(.light)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                        .opacity(0.8)
                            }
                                
                            Divider()
                        
                    }
            
          /*  Text("la tua recensione avrà un peso pari a: 0.8")
                .italic()
                .fontWeight(.light) */
            
        }
       
        
    }
    
 
    
    @ViewBuilder private func vbTitolo() -> some View {
        
        VStack(alignment:.leading,spacing:5) {
            
            CSLabel_1Button(
                placeHolder: "Titolo",
                imageNameOrEmojy: "textformat",
                backgroundColor: .seaTurtle_4)
         
            
            if self.newReview.titolo == nil {
                
                CSTextField_4b(
                    textFieldItem: $titolo,
                    placeHolder: "dai un titolo alla Recensione",
                    showDelete: false) {
                        Image(systemName: "square.and.pencil")
                            .imageScale(.medium)
                            .foregroundColor(self.titolo.count > 3 ? .green : .gray)
                            .padding(.leading,5)
                    }
                    .onSubmit {
                        withAnimation {
                            csCheckAndSubmit()
                        }
                    }
                
            } else {
                
                Text(self.newReview.titolo!)
                   // .fontWeight(.semibold)
                    .fontWeight(.light)
                    .foregroundColor(Color.black)
                    .padding(5)
                    .background {
                        Color.white
                            .cornerRadius(5)
                            .opacity(0.1)
                           
                    }
                   /* .onLongPressGesture {
                        withAnimation {
                            self.titolo = self.newReview.titolo!
                            self.newReview.titolo = nil
                        }
                    } */
                    .onTapGesture(count: 2) {
                        withAnimation {
                            self.titolo = self.newReview.titolo!
                            self.newReview.titolo = nil
                        }
                    }
            }
            
            
        }
        
        
        
    }
    
    private func csCheckAndSubmit() {
        
        let firstStep = csStringCleaner(string: self.titolo)
    
        guard firstStep.count >= 3 else { return }
        
        self.newReview.titolo = firstStep
        self.titolo = ""
    }
    
   
    
    @ViewBuilder private func vbCommento() -> some View {
        
        let maxLenght:Int = 275
        let maxLenghtCondition:Bool = commento.count <= maxLenght
        
        VStack(alignment:.leading,spacing:5) {

            CSLabel_conVB(
                placeHolder: "Commento",
                imageNameOrEmojy: "scribble",
                backgroundColor: .seaTurtle_4) {
                    
                    HStack(spacing:10) {
                        
                        Spacer()
                        
                        if !maxLenghtCondition {
                            
                            Image(systemName: "scissors")
                                .bold()
                                .imageScale(.medium)
                                .foregroundColor(.white)
                                .opacity(0.5)
                        }
                    
                        HStack(spacing:0) {
                        
                            Text("\(commento.count)")
                                .fontWeight(.semibold)
                                .foregroundColor(maxLenghtCondition ? Color.green : Color.red)
                            Text("/\(maxLenght)")
                                .fontWeight(.light)
                            
                        }.opacity(self.commento == "" ? 0.2 : 1.0)
                    }
                }

               // if openDescription ?? false {
            if self.newReview.commento == nil {

                CSTextField_MultiLine(
                    textFieldItem: $commento,
                  //  maxDescriptionLenght: 25,
                    placeHolder: "Scrivi la tua opinione",
                    lineLimit: 5) {
                        
                        csStringCleaner(string: self.commento).count <= 3
                        
                    } saveAction: {
                        
                        withAnimation {
                           checkSaveComment(maxLenght: maxLenght)
                            
                                
                        }
                    }
                    
                } else {
                    
                    Text(newReview.commento!)
                        .fontWeight(.light)
                        .foregroundColor(Color.black.opacity(0.8))
                        .padding(5)
                        .background {
                            Color.white
                                .cornerRadius(5.0)
                                .opacity(0.1)
                        }
                      /*  .onLongPressGesture {
                            
                            withAnimation {
                                self.commento = self.newReview.commento!
                                self.newReview.commento = nil
                            }
                        } */
                        .onTapGesture(count: 2) {
                            
                            withAnimation {
                                self.commento = self.newReview.commento!
                                self.newReview.commento = nil
                            }
                            
                        }
                    
                }
        }
    }
    

    
    private func checkSaveComment(maxLenght:Int) {
        // step 1. controlliamo che il commento senza punti a capo e senza spazi abbia almeno tre caratteri validi.
      //  guard csStringCleaner(string: self.commento).count > 3 else { return }
        
        let stringPosition:String.Index? = {
           
            if self.commento.count >= maxLenght {
                return self.commento.index(self.commento.startIndex, offsetBy: maxLenght)
            }
            else { return nil }
            
        }()
        
        csHideKeyboard()
        
        let cutString:String = {
            
            if let index = stringPosition {
                
               return String(self.commento.prefix(upTo:index))
            } else {
               return self.commento
            }
        }()
        
        let cleanedString = csStringCleaner(string: cutString)
        self.newReview.commento = cleanedString
        self.commento = ""
        
    }
    
    @ViewBuilder private func vbStepperLabel(placeHolder:String,specificValue:Double) -> some View {
        
        HStack {
            
            Text(placeHolder)
                .fontDesign(.monospaced)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.black)
                
            Spacer()
            
            Text("\(specificValue,specifier: "%.1f")")
                .fontWeight(.semibold)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width:50)
                .background {
                    Color.seaTurtle_2.opacity(0.2)
                        .cornerRadius(5.0)
                }

        }
    }
    
    
}

struct ModuloRecensione_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ModuloRecensione(rifDish: rifDish3, dishName: "test name", percorsoDish: .preparazioneFood,backgroundColorView: .seaTurtle_1)
        }
    }
}


struct CSPickerImageView:View {
    
    @Binding var pickedImage:UIImage?
    @Binding var pickerSource:PickerSourceType?
    
    var body: some View {
        
        
        VStack(alignment:.leading,spacing:5.0) {
            
            CSLabel_conVB(
                placeHolder: "Immagine",
                imageNameOrEmojy: "photo",
                backgroundColor: .seaTurtle_4) {
                    
                  /*  CSButton_image(frontImage: "backward.frame", imageScale: .medium, frontColor: .seaTurtle_3,rotationDegree: 90) {
                        self.showSheet.toggle()
                    }*/
                    
                    Menu {
                        
                        Button {
                            self.pickerSource = .library
                        } label: {
                            HStack {
                                
                                Text("Carica dalla libreria")
                                Image(systemName: "photo.stack")
                                   
                            }
                            
                        }

                        Button {
                            self.pickerSource = .camera
                        } label: {
                            
                            HStack {
                                
                                Text("Scatta foto")
                                Image(systemName: "circle.rectangle.dashed")
                                   
                                    }
                             }
                        
                        Button(role: .destructive) {
                            
                            self.pickedImage = nil
                            
                        } label: {
                            
                            HStack {
                                
                                Text("Rimuovi")
                                Image(systemName: "trash")
                                   
                                    }
                        }.disabled(self.pickedImage == nil)
   
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.seaTurtle_3)
                    }
   
                    
                }

            if let image = pickedImage {
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5.0)
                
            } else {
                
                Image(systemName: "photo.on.rectangle.angled")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                    .foregroundColor(.seaTurtle_1)

            }
            
            

            
        }
       /* .sheet(isPresented: $showSheet) {
            Text("Prova")
        } */
        
        
        
    }
    
}

struct SaveButton:View {
    
    @Binding var review:ReviewModel
    
    let description: () -> Text
    let checkPreliminare: () -> Bool
    
    @State private var showDialog: Bool = false
    
    var body: some View {
       
        HStack {
                
            description()
                .italic()
                .fontWeight(.light)
                .font(.caption)

            Spacer()

            CSButton_tight(title: "Salva", fontWeight: .bold, titleColor: Color.white, fillColor: Color.blue) {
                
                let check = checkPreliminare()
                if check { self.showDialog = true}
                else {
                   // self.generalErrorCheck = true
                    
                }
            }
        }
       // .opacity(itemModel == itemModelArchiviato ? 0.6 : 1.0)
       // .disabled(itemModel == itemModelArchiviato)
        .padding(.vertical)
        .confirmationDialog(
                description(),
                isPresented: $showDialog,
                titleVisibility: .visible) { saveButtonDialogView() }
        
    }
    
    @ViewBuilder private func saveButtonDialogView() -> some View {
        

        Button("Pubblica Recensione", role: .destructive) {
            
//
            
        }
        
 
    }
    
}


struct CSTextField_MultiLine: View {
   
   @Binding var textFieldItem: String
 //  let maxDescriptionLenght: Int
   let placeHolder:String
   let lineLimit:Int
    
   let disableCondition: Bool
   let saveAction:() -> Void
    
   public init(
    textFieldItem:Binding<String>,
  //  maxDescriptionLenght: Int = 300,
    placeHolder: String,
    lineLimit: Int = 5,
    disableCondition:() -> Bool,
    saveAction: @escaping () -> Void) {
       
        _textFieldItem = textFieldItem
      //  self.maxDescriptionLenght = maxDescriptionLenght
        self.placeHolder = placeHolder
        self.lineLimit = lineLimit
        self.disableCondition = disableCondition()
        self.saveAction = saveAction
    }

  public var body: some View {
  
      VStack(alignment:.trailing) {
                        
               TextField(placeHolder, text: $textFieldItem, axis: .vertical)
                   .font(.system(.body,design:.rounded))
                   .autocapitalization(.sentences)
                   .disableAutocorrection(true)
                   .keyboardType(.default)
                   .lineLimit(0...lineLimit)
                   .foregroundColor(.black)
                   ._tightPadding()
                   .accentColor(.white)
                   .background(
                    Color.gray
                        .cornerRadius(5.0)
                        .opacity(self.textFieldItem == "" ? 0.2 : 0.6)
                   )
                  // .disabled(self.textFieldItem.count == self.maxDescriptionLenght)
                /*   .overlay(alignment: .trailing) {
                    
                           CSButton_image(frontImage: "x.circle", imageScale: .medium, frontColor: Color.white) {

                               self.textFieldItem = ""
                           }
                           .opacity(textFieldItem == "" ? 0.3 : 1.0)
                           .disabled(textFieldItem == "")
                           .padding(.trailing)
 
                   } */
                   .onChange(of: self.textFieldItem) { newValue in
                       if newValue.count == 0 {
                         //  DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                               csHideKeyboard()
                         //  }
                       }
                   }
                 
               if !disableCondition {
                   
                   CSButton_image(
                    frontImage: "checkmark",
                    imageScale: .large,
                    frontColor: Color.seaTurtle_1.opacity(0.8)) {
                       
                       self.saveAction()
                   }
                    .padding(.horizontal)
                    .padding(.vertical,3)
                    .background {
                        
                        Color.seaTurtle_3
                            .cornerRadius(5.0)
                            .opacity(0.9)
                        }
                   // .disabled(disableCondition)
                   
                    }
               }
       }
   
   // Method
      
 /*  private func saveAction() {
       
       self.isEditorActive = false
       csHideKeyboard()
       // 22.08
       let commento = csStringCleaner(string: description)
       self.revComment.commento = commento
       self.dismissButton = false
           
      
   }
   
   private func cancelAction() {
       
    //   csHideKeyboard()
       
       withAnimation {

           self.description = ""
       
       }
       
   } */
   
}


