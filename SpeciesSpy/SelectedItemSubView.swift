//
//  SpeciesPage.swift
//  SpeciesSpy
//
//  Created by John Newman on 2/9/2025.
//

import SwiftUI

struct SectionView: View {
    
    let title: String
    let items: [String]
    
    var body: some View {
        Text(title)
            .font(.title2)
            .bold()
            .foregroundColor(.white)
            .padding(.horizontal)
        
        ForEach(items, id: \.self) { item in
            Text("• \(item)")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.leading, 30)
        }
    }
}

struct SelectedItemSubView<T: SelectableItem>: View {
    
    let item: T
    @Binding var detailTitle: String?
    
    var body: some View {
        
        if let species = item as? Species {
            ZStack(alignment: .center) {
                LinearGradient(colors: species.speciesTheme, startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                ScrollView {
                    
                    //button should become available on selected item screen, to save as a favorite, and then append to the favorites
//                Button("fav", systemImage: "heart") {
//                    
//                }
//                .padding(.horizontal, 2)
//                .foregroundStyle(.white)
//                .bold()
//                .font(.title2)
//                .shadow(color: .black, radius: 3, x: -1, y: 5)
                    
                    Text(species.speciesImage)
                        .font(.system(size: 65))
                        .padding()
                        .background(.black)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 16) {
                        SectionView(title: "Attributes", items: species.attributes)
                        SectionView(title: "Features", items: species.features)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }
            .navigationTitle(species.type)
            .onAppear {
                detailTitle = species.type
            }
            .onDisappear {
                detailTitle = nil
            }
            
        }else if let ships = item as? Ship {
            ZStack(alignment: .center) {
                LinearGradient(colors: ships.shipTheme, startPoint: .top, endPoint: .bottom).ignoresSafeArea()
                ScrollView {
                    
                    Text(ships.shipImage)
                        .font(.system(size: 65))
                        .padding()
                        .background(.black)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 16) {
                        SectionView(title: "Attributes", items: ships.attributes)
                        SectionView(title: "Features", items: ships.features)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }
            .navigationTitle(ships.type)
            .onAppear {
                detailTitle = ships.type
            }
            .onDisappear {
                detailTitle = nil
            }
        }
        
        
    }
}

//#Preview {
//    NavigationStack {
//        SelectedItemSubView(species: Species(speciesTheme: [.indigo, .mint], speciesImage: "alien", type: "Pleiadian", attributes: ["One of the most ancient races of beings"], features: ["Can fly", "Can breathe underwater"]))
//    }
//}
