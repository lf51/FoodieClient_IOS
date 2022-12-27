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
    @State private var mapTree:MapTree<DishModel,CategoriaMenu>?
    @State private var filterCore:CoreFilter<DishModel> = CoreFilter()
    @State private var openFilter:Bool = false
    @State private var openSort:Bool = false
    
    @State private var isShowingScanner:Bool = true
    
    var body: some View {
        
        NavigationStack {
            
            let container:[DishModel] = self.viewModel.ricercaFiltra(containerPath: \.allMyDish, coreFilter: filterCore)
            
            FiltrableContainerView(
            backgroundColorView: backgroundColorView,
            title: "Menu",
            filterCore: $filterCore,
            placeHolderBarraRicerca: "Ricerca piatti,ingredienti,allergeni",
            buttonColor: CatalogoColori.seaTurtle_3.color(),
            elementContainer: container,
            mapTree:mapTree,
            thirdButtonAction: { self.openFilter.toggle() },
            trailingView: { vbScanReload() },
            filterView: { vbFilterView(container: container) },
            sorterView: { vbSorterView() },
            elementView: { dish in
                
                vbContent(element: dish)
                
            })
            .popover(isPresented: $isShowingScanner, content: {
                CodeScannerView(codeTypes: [.qr]) { result in
                    handleScan(result: result)
                    
                }.presentationDetents([.height(600)])

            })
           
            
        
        }// chiusa NavStack
        
    }
    
    // Method
    
    
    @ViewBuilder private func vbContent(element:DishModel) -> some View {
        
            Text(element.intestazione)
                .foregroundColor(Color.black)
        
        
    }
    
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
              0//  container.filter({ })
            }
        
        MyFilterRow(
            allCases: TipoDieta.allCases,
            filterCollection: $filterCore.filterProperties.dietePRP,
           // filterCollection: $filterCore.properties.dietePRP,
            selectionColor: Color.orange.opacity(0.6),
            imageOrEmoji: "person.fill.checkmark",
            label: "Adatto alla dieta") { value in
               1//container.filter({})
            }
        
        
        
    }
    
    @ViewBuilder private func vbSorterView() -> some View {
        
        let coloreSelezione = CatalogoColori.seaTurtle_2.color()
        
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
    
    
    @ViewBuilder private func vbScanReload() -> some View {
        
        let cloudDataCreated:Bool = {
           
            self.viewModel.cloudDataCompiler != nil &&
            self.viewModel.cloudData != nil
            
        }()
            
        let frontColor = CatalogoColori.seaTurtle_1.color()
        let backColor = CatalogoColori.seaTurtle_3.color()
        
        CSButton_image(
            activationBool: cloudDataCreated,
            frontImage: "arrow.clockwise.icloud.fill",
            backImage: "camera.fill",
            imageScale: .large,
            backColor: backColor,
            frontColor: frontColor) {
                
                scanReloadAction(dataIn: cloudDataCreated)

            }.disabled(self.isShowingScanner)
        
    }
    
   private func scanReloadAction(dataIn:Bool) {
        
        if dataIn {
            
            self.viewModel.compilaCloudDataFromFirebase()
            
        } else {
            
            self.isShowingScanner.toggle()
            
        }
        
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
        QRScanView(backgroundColorView: CatalogoColori.seaTurtle_1.color())
            .environmentObject(ClientVM())
    }
}
