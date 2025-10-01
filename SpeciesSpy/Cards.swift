//
//  SpeciesCard.swift
//  SpeciesSpy
//
//  Created by John Newman on 2/9/2025.
//

import SwiftUI

struct Cards: View {
    
    var type: String
    var textShadowColor: Color
    
    var body: some View {
        ZStack {
            
            Text(type)
                .font(.title)
                .foregroundStyle(.white)
                .bold()
                .frame(width: 350, height: 75)
                .background(.black)
                .shadow(color: textShadowColor, radius: 5)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(5)
                .shadow(color: .white, radius: 3)
                .clipShape(RoundedRectangle(cornerRadius: 23))
        }
    }
}

#Preview {
    Cards(type: "Pleiadian", textShadowColor: .red)
}
