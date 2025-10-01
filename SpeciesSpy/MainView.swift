//
//  MainView.swift
//  SpeciesSpy
//
//  Created by John Newman on 4/9/2025.
//

//MARK: NOTES FOR PROJECT
/*
 ADD A FAVORITES SECTION ON THE HOME PAGE - PERHAPS A SHEET
 */

import SwiftUI

//Protocol for data typ selection
protocol SelectableItem: Identifiable {
    //these variables collect the types from the other structs to allow 'connection'
    var id: UUID { get }
    var type: String { get }
    var textShadowColor: Color { get }
}

//Alien species struct
struct Species: Identifiable, SelectableItem {
    var id = UUID()
    var speciesTheme: [Color]
    var speciesImage: String
    var textShadowColor: Color
    var type: String
    var attributes: [String]
    var features: [String]
}

//Alien ship struct
struct Ship: Identifiable, SelectableItem {
    var id = UUID()
    var shipTheme: [Color]
    var shipImage: String
    var textShadowColor: Color
    var type: String
    var attributes: [String]
    var features: [String]
}

//set this as hashable for persistent app selection
enum Tabs: String {
    case home = "Home", species = "Species", ships = "Ships", search
}

struct MainView: View {
    
    @State var species = [Species]()
    @State var ships = [Ship]()
    
    //make this @appstorage for persistence
    @State var selectedTab: Tabs = .home
    
    var filteredItems: [any SelectableItem] {
        search(for: searchString)
    }
    
    //MARK: FAVORITES / FAV TRACKING
    //add favorites here from the selected 'view'
    //make them appear as tappable cards like the other views
    //make favorites of type: SelectableItem to == both Species and Ship
    //review search func for how to set up favorites
    @State var favorites: [String] = []
    @State var detailTitle: String? = nil
    
    @State var showFavoritesSheet: Bool = false
    
    @State var popoverIsPresented: Bool = false
    
    
    @State var searchString: String = ""
    
    var body: some View {
        TabView(selection: $selectedTab) {
            //MARK: HOME TAB
            Tab("", systemImage: "house", value: .home) {
            }
            //MARK: SPECIES TAB
            Tab("", systemImage: "leaf", value: .species) {
                ItemSelectView(items: species, title: "Species", detailTitle: $detailTitle)
            }
            //MARK: SHIPS TAB
            Tab("", systemImage: "airplane", value: .ships) {
                ItemSelectView(items: ships, title: "Ships", detailTitle: $detailTitle)
            }
            //MARK: SEARCH TAB
            Tab(value: .search, role: .search) {
                NavigationStack {
                    ScrollView {
                        VStack {
                            ForEach(filteredItems, id: \.id) { item in
                                    Cards(type: item.type, textShadowColor: item.textShadowColor)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .navigationTitle("Search")
                    .searchable(text: $searchString)
                    .animation(.default, value: searchString)
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tint(selectedTab == .home ? .indigo : .white)
        .tabViewBottomAccessory {
            
            switch (selectedTab, detailTitle != nil) {
            case (.search, _): EmptyView()
            case (.home, false):
                HStack {
                    Text(selectedTab.rawValue)
                    Button {
                        showFavoritesSheet.toggle()
                    } label: {
                        ZStack {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.black)
                                .frame(width: 20, height: 20)
                            Image(systemName: "heart")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.red)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                
            case (.species, false), (.ships, false):
                Text(selectedTab.rawValue)
                
            case (.species, true), (.ships, true):
                Button {
                    if let title = detailTitle {
                        if !favorites.contains(title) {
                            favorites.append(title)
                        }else {
                            favorites.removeAll { $0 == title }
                        }
                    }
                } label: {
                    Image(systemName: favorites.contains(detailTitle ?? "") ? "heart.fill" : "heart")
                }
                
            case (.home, true): EmptyView()
            }
        }
        .onAppear {
            if species.isEmpty {
                fetchSpecies()
            }
            if ships.isEmpty {
                fetchShips()
            }
        }
        .sheet(isPresented: $showFavoritesSheet){
            //display all favorited items from favorite array
            //separate out into a view later
            ForEach(favorites, id: \.self) { favorite in
                Text(favorite)
            }
        }
    }
    
    func fetchSpecies() {
        let newSpecies: [Species] = [
            Species(speciesTheme: [.indigo, .mint], speciesImage: "👽", textShadowColor: .blue, type: "Pleiadian", attributes: ["humanoid", "blonde hair", "blue eyes"], features: []),
            Species(speciesTheme: [.orange, .gray], speciesImage: "🦎", textShadowColor: .green, type: "Reptilian", attributes: ["scaly", "green", "cat-like eyes"], features: ["cold-blooded", "can regenerate limbs"]),
            Species(speciesTheme: [.gray, .black, .cyan], speciesImage: "🛸", textShadowColor: .white, type: "Gray", attributes: ["Small (4-5ft tall)", "Hairless", "Slit-like mouth", "Big eyes"], features: ["Strong telepathic abilities", "Highly technological", "Potential mind control abilities", "Potential memory erasure abilities"])
        ]
        species.append(contentsOf: newSpecies)
    }
    
    func fetchShips() {
        let newShips: [Ship] = [
            Ship(shipTheme: [.gray, .blue, .indigo], shipImage: "🛸", textShadowColor: .yellow, type: "Saucer", attributes: ["Metallic", "Visibile dome on top side"], features: ["Small footprint", "Rotates forward approximately 45˚ upon movement"])
        ]
        ships.append(contentsOf: newShips)
    }
    
    func search(for searchTerm: String) -> [any SelectableItem] {
        
        let allItems: [any SelectableItem] = species.map { $0 as any SelectableItem } + ships.map { $0 as any SelectableItem }
        
        guard !searchTerm.isEmpty else { return allItems }
        
        return allItems.filter { $0.type.localizedCaseInsensitiveContains(searchTerm) }
    }
    
    //create function to find favorite?
    
}

#Preview {
    MainView()
        .preferredColorScheme(ColorScheme.dark)
}
