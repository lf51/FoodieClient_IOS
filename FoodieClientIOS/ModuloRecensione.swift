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
    @State private var openDescription:Bool?

   // @State private var rateModel:RateModel = RateModel() // Temporaneo.. andrà inglobato nel dishratingModel
    
    //Pick Image
    @State private var pickerSource:PickerSourceType?
    @State private var pickedImage:UIImage?
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
                
                if description.count < 70 { return "\n• Articola con più parole la tua opinione "}
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
                    showDelete: true) {
                        Image(systemName: "square.and.pencil")
                            .padding(.leading,5)
                    }
                    .onSubmit {
                        withAnimation {
                            csCheckAndSubmit()
                        }
                    }
                
            } else {
                
                Text(self.newReview.titolo!)
              //  Text("Amazing !!")
                    .fontWeight(.semibold)
                    .padding(5)
                    .background {
                        Color.white
                            .cornerRadius(5)
                            .opacity(0.1)
                           
                    }
                    .onLongPressGesture {
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
        
        VStack(alignment:.leading,spacing:5) {
            
            CSLabel_1Button(
                placeHolder: "Commento",
                imageNameOrEmojy: "scribble",
                imageColor: .black,
                backgroundColor: .seaTurtle_4
                
                 )

                if openDescription ?? false {
                    
                  /*  CSTextField_ExpandingBox(itemModel: $newReview, dismissButton: $openDescription, maxDescriptionLenght: 275) */
                    
                    CSTextField_CommentReview(
                        revComment: $newReview,
                        dismissButton: $openDescription,
                        maxDescriptionLenght: 275)
                    
                } else {
                    
                    Text(newReview.commento == nil ? "Premere a lungo per scrivere" : newReview.commento!)
                        .italic(newReview.commento == nil)
                        .fontWeight(.light)
                        .onLongPressGesture {
                            self.openDescription = true
                        }
                    
                }
                
                
                
                
            
            
        }
        
        
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

struct CSTextField_CommentReview: View {
   
  // @EnvironmentObject var viewModel: FoodieViewModel
   @Binding var revComment: ReviewModel
   @Binding var dismissButton: Bool?
   var maxDescriptionLenght: Int
   
   @State private var description: String
   
   @State private var isEditorActive: Bool = false
   @State private var isTextChanged: Bool = false
  
   init(
    revComment: Binding<ReviewModel>,
    dismissButton: Binding<Bool?>,
    maxDescriptionLenght: Int = 300) {
       
     //  _itemModel = itemModel
        _revComment = revComment
       _dismissButton = dismissButton
       let newDescription = revComment.commento.wrappedValue ?? ""
       _description = State(wrappedValue: newDescription)
       self.maxDescriptionLenght = maxDescriptionLenght
   }
   
  public var body: some View {
  
           VStack {
                        
               TextField("Articola la tua valutazione", text: $description, axis: .vertical)
                   .font(.system(.body,design:.rounded))
                   .foregroundColor(isEditorActive ? Color.white : Color.black)
                   .autocapitalization(.sentences)
                   .disableAutocorrection(true)
                   .keyboardType(.default)
                   .lineLimit(0...5)
                   .padding()
                   .background(Color.white.opacity(isEditorActive ? 0.2 : 0.05))
                   .cornerRadius(5.0)
                   .overlay(alignment: .trailing) {
                       CSButton_image(frontImage: "x.circle.fill", imageScale: .medium, frontColor: Color.white) { cancelAction() }
                       .opacity(description == "" ? 0.6 : 1.0)
                       .disabled(description == "")
                       .padding(.trailing)
                   }
                   .onTapGesture {
                       
                       withAnimation {
                           isEditorActive = true
                       }
                       
                   }
                   .onChange(of: description) { newValue in
                       
                       if newValue != revComment.commento {
                           isTextChanged = true }
                       else { isTextChanged = false}
                       }
               
               if isEditorActive {
                       
                       HStack {
                               CSButton_tight(
                                   title: "Undo",
                                   fontWeight: .heavy,
                                   titleColor: .red,
                                   fillColor: .clear) {
                                       
                                       withAnimation {
                                           self.description = revComment.commento ?? ""
                                       }
                                   }
                         
                           Spacer()
                           
                           HStack(spacing:0) {
                               
                               Text("\(description.count)")
                                   .fontWeight(.semibold)
                                   .foregroundColor(description.count <= maxDescriptionLenght ? Color.blue : Color.red)
                               Text("/\(maxDescriptionLenght)")
                                   .fontWeight(.light)
                               
                           }
                           
                           CSButton_tight(
                               title: "Salva",
                               fontWeight: .heavy,
                               titleColor: .green,
                               fillColor: .clear) {

                                   self.saveAction()
                                  /* self.isEditorActive = false
                                   csHideKeyboard()
                                   self.itemModel.descrizione = description */
                                 //  self.dismissButton.toggle()
                                   
                               }
                       }
                       .opacity(isTextChanged ? 1.0 : 0.6)
                       .disabled(!isTextChanged)
                   
                   }

               }
       }
   
   // Method
   
  /* private func saveText() {
       
       self.isEditorActive = false
       csHideKeyboard()

       viewModel.updateItemModel(messaggio: "Test") { () -> M in
           
           var varianteProperty = itemModel
           varianteProperty.descrizione = description
           return varianteProperty
       }
  
   } */ // Salvataggio spostato nella View MAdre in data 27.06
   
   private func saveAction() {
       
       self.isEditorActive = false
       csHideKeyboard()
       // 22.08
       let commento = csStringCleaner(string: description)
       self.revComment.commento = commento
       self.dismissButton = false
           
       
      // self.itemModel.descrizione = newDescription
      // self.dismissButton = false
       //
      // self.itemModel.descrizione = description
      
   }
   
   private func cancelAction() {
       
    //   csHideKeyboard()
       
       withAnimation {
        //   self.isEditorActive = false
         //  self.showPlaceHolder = itemModel.descrizione == ""
         //  self.description = itemModel.descrizione
           self.description = ""
       
       }
       
   }
   
}
