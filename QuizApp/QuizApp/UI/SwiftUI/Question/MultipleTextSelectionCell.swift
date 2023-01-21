//  MultipleTextSelectionCell.swift
//  Created by aa on 1/19/23.

import SwiftUI

struct MultipleTextSelectionCell: View {
    @Binding var option: MultipleSelectionOption

    var body: some View {
        Button {
            option.select()
        } label: {
            HStack {
                Rectangle()
                    .strokeBorder(option.isSelected ? .blue : .secondary, lineWidth: 2.5)
                    .overlay(
                        Rectangle()
                            .fill(option.isSelected ? .blue : .clear)
                            .padding(8)
                    )
                    .frame(width: 40.0, height: 40.0)

                Text(option.text)
                    .font(.largeTitle)
                    .foregroundColor(option.isSelected ? .blue : .secondary)

                Spacer()
            }.padding()
        }
    }
}

struct MultipleTextSelectionCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MultipleTextSelectionCell(option: .constant(.init(text: "A text", isSelected: false)))

            MultipleTextSelectionCell(option: .constant(.init(text: "A text", isSelected: true)))
        }
        .previewLayout(.sizeThatFits)
    }
}
