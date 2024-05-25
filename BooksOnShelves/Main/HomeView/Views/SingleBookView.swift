//
//  SingleBookView.swift
//  BooksOnShelves
//
//  Created by Віка Горєлова on 25.03.2024.
//

import SwiftUI

struct SingleBookView: View {
    var body: some View {
        VStack{
            Form{
                Text("")
                HStack{
                    TLButton(title: "Delete", action: {})
                    TLButton(title: "Edit", action: {})
                }
            }
        }
    }
}

#Preview {
    SingleBookView()
}
