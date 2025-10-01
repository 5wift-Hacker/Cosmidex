//
//  ContentView.swift
//  SpeciesSpy
//
//  Created by John Newman on 2/9/2025.
//

import SwiftUI

struct ItemSelectView<T: SelectableItem>: View {
    
    //[T] sets up and matches the struct type where you want the protocol struct to be accessed
    //allows SelectableItem to be found in scope and then accessible
    let items: [T]
    let title: String
    @Binding var detailTitle: String?
    
    @Namespace var nameSpace
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.mint, .cyan, .blue, .purple], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                ScrollView {
                    VStack {
                        ForEach(items) { item in
                            NavigationLink {
                                SelectedItemSubView(item: item, detailTitle: $detailTitle)
                                    .navigationTransition(.zoom(sourceID: item.id, in: nameSpace))
                            }label: {
                                Cards(type: item.type, textShadowColor: item.textShadowColor)
                            }
                            .matchedTransitionSource(id: item.id, in: nameSpace)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle(title)
        }
    }
}

//#Preview {
//    ItemSelectView(items: [
//        Species(speciesTheme: [.gray], speciesImage: "", type: "", attributes: [], features: [])
//    ], title: "")
//}
