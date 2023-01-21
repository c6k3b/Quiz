//  ResultAnswerCell.swift
//  Created by aa on 1/21/23.

import SwiftUI

struct ResultAnswerCell: View {
    let model: PresentableAnswer

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text(model.question)
                .font(.title)

            Text(model.answer)
                .font(.title2)
                .foregroundColor(/*@START_MENU_TOKEN@*/.green/*@END_MENU_TOKEN@*/)

            if let wrongAnswer = model.wrongAnswer {
                Text(wrongAnswer)
                    .font(.title2)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.red/*@END_MENU_TOKEN@*/)
            }
        }.padding(.vertical)
    }
}

struct ResultAnswerCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ResultAnswerCell(
                model: .init(
                    question: "What's the answer to question #001?",
                    answer: "A correct answer",
                    wrongAnswer: "A wrong answer"
                )
            )

            ResultAnswerCell(
                model: .init(
                    question: "What's the answer to question #002?",
                    answer: "A correct answer",
                    wrongAnswer: nil
                )
            )
        }.previewLayout(.sizeThatFits)
    }
}
