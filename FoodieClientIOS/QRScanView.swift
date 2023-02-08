//
//  QRScanView.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 07/12/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import CodeScanner
import MyFilterPackage

struct QRScanView:View {
    
    @EnvironmentObject var viewModel:ClientVM
    let backgroundColorView:Color
    
   // @State private var filterProperties:DishModel.FilterProperty = DishModel.FilterProperty()
  //  @State private var mapTree:MapTree<DishModel,CategoriaMenu>?
    @State private var filterCore:CoreFilter<DishModel> = CoreFilter()
   // @State private var openFilter:Bool = false
   // @State private var openSort:Bool = false
    @State private var mostraVistaEspansa:Bool = true
    
    @State private var isShowingScanner:Bool = true
    @State private var currentDishForRatingList:DishModel?
   // @State private var preSelection:[DishModel] = []
   // @State private var subTotalPrice:Double = 10.5 // 10.01.23 somma i prezzi. Valutare se incorporarlo nella preSelection creando un dizionario
        
    var body: some View {
        
        NavigationStack(path: self.$viewModel.menuPath) {
            
            let container:[DishModel] = self.viewModel.ricercaFiltra(containerPath: \.allMyDish, coreFilter: filterCore)
            let cloudDataCreated:Bool = {
                
                 self.viewModel.cloudDataCompiler != nil &&
                 self.viewModel.cloudData != nil
                 
             }()
            
            let mapTree = MapTree(
                mapProperties: self.viewModel.allMyCategories,
                kpPropertyInObject: \DishModel.categoriaMenu,
                labelColor: .seaTurtle_2)
          
                FiltrableContainerView(
                backgroundColorView: .seaTurtle_1,
                title: "Menu",
                filterCore: $filterCore,
                placeHolderBarraRicerca: "Ricerca piatto, ingrediente, allergene",
                paddingHorizontal: 10,
                buttonColor: .seaTurtle_3,
                elementContainer: container,
                mapTree: mapTree, // NOTA 24.01 MAPTREE
                generalDisable: !cloudDataCreated,
               // mapButtonAction: { thirdButtonAction() },
                //mapButtonAction: nil,
                trailingView: { vbTrailingBar(cloudDataCreated) },
                filterView: { vbFilterView(container: container) },
                sorterView: { vbSorterView() },
                elementView: { dish in
                    vbContent(element: dish)
                        .id(self.mostraVistaEspansa) },
                onRefreshAction: {
                    scanReloadAction()
                })
                .popover(isPresented: $isShowingScanner,attachmentAnchor: .point(.leading),arrowEdge: .bottom, content: {
                    
                    CodeScannerView(codeTypes: [.qr]) { result in
                        handleScan(result: result)
                    }.presentationDetents([.height(600)])
                    
                })
                .popover(item: $currentDishForRatingList,attachmentAnchor: .point(.trailing), arrowEdge: .trailing, content: { dish in
                  
                    DishRatingListView(
                     dishItem: dish,
                     backgroundColorView: backgroundColorView,
                     readOnlyViewModel: self.viewModel)
                    //.presentationDetents([.height(675)])
                    .presentationDetents([.large])
                    
                })
                .navigationDestination(for: DestinationPathView.self) { destination in
                    destination.destinationAdress(
                        backgroundColorView: backgroundColorView,
                        readOnlyViewModel: viewModel)
                } // 25.01.23 Deprecato in futuro
 
        }// chiusa NavStack
        
    }
    
    // Method
    /* private func thirdButtonAction() {
        
       /* if mapTree == nil {
            
            self.mapTree = MapTree(
                mapProperties: self.viewModel.allMyCategories,
                kpPropertyInObject: \DishModel.categoriaMenu,
                labelColor: .seaTurtle_2)
            
        } else {
            
            self.mapTree = nil
        } */
    } */
    
    @ViewBuilder private func vbContent(element:DishModel) -> some View {
        
        DishModelRow_ClientVersion(
            viewModel: viewModel,
            item: element,
            rowColor: backgroundColorView,
            rowOpacity: 0.15,
            rowBoundReduction: 20, //rowBoundReduction
            vistaEspansa: mostraVistaEspansa) {
                
                self.viewModel.checkSelection(rif: element.id)
                
            } selectorAction: {
                
                self.viewModel.preSelectionLogic(rif: element.id)
                
            } reviewButton: {
                
                self.currentDishForRatingList = element // 03.02.23 da ripristinare e trovare collocazione codice seguente messo qui in PROVA
              /*  self.viewModel.menuPath.append(DestinationPathView.moduloNuovaRecensione(element)) */
               
            }

    }
    
   /* private func checkSelection(rif:String) -> Bool {
        
        let value = self.viewModel.preSelectionRif.contains(rif)
        print("[0] CheckSelection: Value is \(rif) -> Return is \(value.description)")
        return value
    }
    
    private func preSelectionLogic(rif:String) {
        
        var dishes = self.viewModel.preSelectionRif
        
        if let index = dishes.firstIndex(of: rif) {
            
            dishes.remove(at: index)
            
        } else {
            
            dishes.append(rif)
        }
        
        self.viewModel.preSelectionRif = dishes
                
        print("[1] preSelectionLogic: Value is -> \(rif)")

    }*/
    
    @ViewBuilder private func vbFilterView(container:[DishModel]) -> some View {

        // Oggetti MyFilterRow
        MyFilterRow(
            allCases: DishModel.PercorsoProdotto.allCases,
            filterCollection: $filterCore.filterProperties.percorsoPRP,
            //filterCollection: $filterCore.properties.percorsoPRP,
            selectionColor: Color.white.opacity(0.5),
            imageOrEmoji: "fork.knife",
            label: "Prodotto") { value in
             
                container.filter({$0.percorsoProdotto == value }).count
            }
        
        MyFilterRow(
            allCases: self.viewModel.allMyCategories,
            filterCollection: $filterCore.filterProperties.categorieMenu,
           // filterCollection: $filterCore.properties.categorieMenu,
            selectionColor: Color.yellow.opacity(0.7),
            imageOrEmoji: "list.bullet.indent",
            label: "Categoria") { value in
                container.filter({$0.categoriaMenu == value.id}).count
            }
        
        MyFilterRow(
            allCases: DishModel.BasePreparazione.allCase,
            filterProperty: $filterCore.filterProperties.basePRP,
           // filterProperty: $filterCore.properties.basePRP,
            selectionColor: Color.brown,
            imageOrEmoji: "leaf",
            label: "Preparazione a base di") { value in
                container.filter({
                    $0.calcolaBaseDellaPreparazione(readOnlyVM: self.viewModel) == value
                }).count
            }
        
        MyFilterRow(
            allCases: TipoDieta.allCases,
            filterCollection: $filterCore.filterProperties.dietePRP,
           // filterCollection: $filterCore.properties.dietePRP,
            selectionColor: Color.orange.opacity(0.6),
            imageOrEmoji: "person.fill.checkmark",
            label: "Adatto alla dieta") { value in
                container.filter({
                    $0.returnDietAvaible(viewModel: self.viewModel).inDishTipologia.contains(value)
                }).count
            }
        
        MyFilterRow(
            allCases: ProduzioneIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.produzioneING,
            selectionColor: Color.blue,
            imageOrEmoji: "checkmark.shield",
            label: "Qualità") { value in
                container.filter({
                    $0.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.produzione, quality: value)
                }).count
            }
        
        MyFilterRow(
            allCases: ProvenienzaIngrediente.allCases,
            filterProperty: $filterCore.filterProperties.provenienzaING,
            selectionColor: Color.blue,
            imageOrEmoji: nil) { value in
                container.filter({
                    $0.hasAllIngredientSameQuality(viewModel: self.viewModel, kpQuality: \.provenienza, quality: value)
                }).count
            }
        
        
        MyFilterRow(
            allCases: AllergeniIngrediente.allCases,
            filterCollection: $filterCore.filterProperties.allergeniIn,
            selectionColor: Color.red.opacity(0.7),
            imageOrEmoji: "allergens",
            label: "Allergeni Contenuti") { value in
                container.filter({
                    $0.calcolaAllergeniNelPiatto(viewModel: self.viewModel).contains(value)
                }).count
            }
        
    }
    
    @ViewBuilder private func vbSorterView() -> some View {
        
        let coloreSelezione:Color = .seaTurtle_2
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .topRated,
            coloreScelta: coloreSelezione)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .mostRated,
            coloreScelta: coloreSelezione)
        
        MySortRow(
            sortCondition: $filterCore.sortConditions,
            localSortCondition: .topPriced,
            coloreScelta: coloreSelezione)
        
    }
    
    @ViewBuilder private func vbTrailingBar(_ cloudDataCreated:Bool) -> some View {
        
        let preSelection = self.viewModel.preSelectionRif
        let selectionIsEmpty = preSelection.isEmpty
        
        let value:(emptyString:String,color:Color,disableLink:Bool) = {
           
            if filterCore.filterProperties.showFavourites {
                
                return (".fill",.seaTurtle_3,false)
                
            } else {
                let color:Color = selectionIsEmpty ? .seaTurtle_1 : .seaTurtle_3
                return ("",color,selectionIsEmpty)
                
            }
            
           /* if preSelection.isEmpty {
                return ("",.seaTurtle_1,true)
            } else {
                return (".fill",.seaTurtle_3,false)
            } */
            
        }()
        
      /*  let cloudDataCreated:Bool = {
           
            self.viewModel.cloudDataCompiler != nil &&
            self.viewModel.cloudData != nil
            
        }() */
        
        HStack(spacing:10) {
            
            CSButton_image(
                activationBool: self.mostraVistaEspansa,
                frontImage: "arrow.right.and.line.vertical.and.arrow.left",
                backImage: "arrow.left.and.line.vertical.and.arrow.right",
                imageScale: .large,
                backColor: .seaTurtle_4,
                frontColor: .seaTurtle_3) {
                    withAnimation {
                        self.mostraVistaEspansa.toggle()
                    }
                }
                .opacity(cloudDataCreated ? 1.0 : 0.6)
                .disabled(!cloudDataCreated)
            
            if cloudDataCreated {
                
                Button {
                    withAnimation(.easeIn(duration: 0.5)) {
                        self.filterCore.filterProperties.showFavourites.toggle()
                    }
                } label: {
                    HStack(alignment:.top,spacing: 0) {
                        
                        Image(systemName: "heart\(value.emptyString)")
                            .imageScale(.large)
                        
                        Text("\(preSelection.count,format: .number)")
                            .font(.system(.caption, design: .monospaced, weight: .semibold))
                        
                    }
                    .foregroundColor(value.color)
                }.disabled(value.disableLink)

                
               /* NavigationLink(value: DestinationPathView.preSelezionePiatti) {
                    
                    HStack(alignment:.top,spacing: 0) {
                        
                        Image(systemName: "heart\(value.emptyString)")
                            .imageScale(.large)
                        
                        Text("\(preSelection.count,format: .number)")
                            .font(.system(.caption, design: .monospaced, weight: .semibold))
                        
                    }
                    .foregroundColor(value.color)
                }.disabled(value.disableLink) */
               
                
            } else {
                
                CSButton_image(
                    frontImage: "camera.fill",
                    imageScale: .large,
                    frontColor: .seaTurtle_1) {
                            
                            self.isShowingScanner.toggle()

                        }.disabled(self.isShowingScanner)
                
               
            }
  
        }
    }
    
    
    private func scanReloadAction() {
        
        let cloudDataCreated:Bool = {
           
            self.viewModel.cloudDataCompiler != nil &&
            self.viewModel.cloudData != nil
            
        }()
        
        guard cloudDataCreated else {
            
            self.isShowingScanner.toggle()
            return
        }

            self.viewModel.compilaCloudDataFromFirebase()
    
    }
    
   private func handleScan(result:Result<ScanResult,ScanError>) {
        
        // handle QRCode
        isShowingScanner = false
        
        switch result {
        case .success(let success):

            self.viewModel.cloudDataCompiler = CloudDataCompiler(userUID: success.string)
            
            self.viewModel.compilaCloudDataFromFirebase()
            
            print("link:\(success.string) and type:\(success.type.rawValue)")
      
            
        case .failure(let failure):
            print("Scan Failure :\(failure.localizedDescription)")
        }
        
    }
    
}

struct QRScanView_Previews: PreviewProvider {
    static var previews: some View {
        QRScanView(backgroundColorView:.seaTurtle_1)
            .environmentObject(testAccount)
    }
}
