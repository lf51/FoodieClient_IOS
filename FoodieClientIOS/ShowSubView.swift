//
//  ScanAndShowView.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 20/12/22.
//

import SwiftUI
import MyPackView_L0

public struct FiltrableContainerView<
    Content:View,
    TrailingView:View,
    FilterView:View,
    SorterView:View,
    V:MyProFilter_L0>: View {
    
    let backgroundColorView:Color
    let title:String
    @Binding var filterCore:FilterPropertyCore<V>
    let placeHolderBarraRicerca:String
    let altezzaPopOver:CGFloat
    let thirdButtonAction: () -> Void
    @ViewBuilder var content:Content
    @ViewBuilder var trailingView:TrailingView
    @ViewBuilder var popOverFilter:FilterView
    @ViewBuilder var popOverSorter:SorterView
    
    @State private var openFilter:Bool = false
    @State private var openSort:Bool = false
    
    /// ScrollReader inserito in un Vstack a sua volta dentro una CsZStaclCustom.
    /// - Parameters:
    ///   - backgroundColorView: color sfondo della ZStack inseribile in un Navigation Stack
    ///   - title: titolo qualora inserita in una navStack
    ///   - filterCore: istanza di un filterpropertyCore
    ///   - placeHolderBarraRicerca: placeholder della barra di ricerca
    ///   - altezzaPopOver: altezza della view in popOver. Di default 400
    ///   - thirdButtonAction: azione per il terzo bottone. Azione di Mapping
    ///   - content: Contenuto del corpo, inserito in una scrollreader in posizione proxy 1. Sullo zero abbiamo la stringa di ricerca nascosta
    ///   - trailingView: viewbuilder da mettere nella toolbar lato trailing
    ///   - filterView: viewBuilder per un popOver dove mostrare i filtri
    ///   - sorterView: viewBuilder per un popOver dove mostrare le condizioni per l'ordinamento
    public init(backgroundColorView: Color, title: String, filterCore: Binding<FilterPropertyCore<V>>, placeHolderBarraRicerca: String,altezzaPopOver:CGFloat = 400, thirdButtonAction: @escaping () -> Void, content: Content, trailingView: TrailingView, filterView:FilterView,sorterView:SorterView) {
        self.backgroundColorView = backgroundColorView
        self.title = title
        self.filterCore = filterCore
        self.placeHolderBarraRicerca = placeHolderBarraRicerca
        self.altezzaPopOver = altezzaPopOver
        self.thirdButtonAction = thirdButtonAction
        self.content = content
        self.trailingView = trailingView
        self.popOverFilter = filterView
        self.popOverSorter = sorterView
    }
    
   public var body: some View {
        
        CSZStackVB(title: title, backgroundColorView: backgroundColorView) {
            
            VStack {
                CSDivider()
                ScrollView(showsIndicators: false) {
                    ScrollViewReader { proxy in
                        
                        CSTextField_4(textFieldItem: $filterCore.stringaRicerca, placeHolder: placeHolderBarraRicerca, image: "text.magnifyingglass", showDelete: true).id(0)
                        
                        CSDivider()
                        
                        content
                            .id(1)
                            .onAppear { proxy.scrollTo(1, anchor: .top) }
                    }
                }
            }

        }
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                let sortActive = self.filterCore.conditions != nil
                
                FilterSortMap_Bar(
                    openFilter: $openFilter,
                    openSort: $openSort,
                    filterCount: filterCore.countChange,
                    sortActive: sortActive) {
                        
                        self.thirdButtonAction()
                    }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                trailingView
            }
        }
        .popover(
            isPresented: $openFilter,
            attachmentAnchor: .point(.top)) {
            popOverFilter
                    .presentationDetents([.height(altezzaPopOver)])
        }
        .popover(
            isPresented: $openSort,
            attachmentAnchor: .point(.top)) {
                popOverSorter
                    .presentationDetents([.height(altezzaPopOver)])
            }
            
       
    }
}
