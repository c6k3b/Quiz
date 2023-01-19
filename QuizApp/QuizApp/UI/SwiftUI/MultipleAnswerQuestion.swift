//  MultipleAnswerQuestion.swift
//  Created by aa on 1/19/23.

import SwiftUI

struct MultipleAnswerQuestion: View {
    let title: String
    let question: String
    @State var store: MultipleSelectionStore

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            QuestionHeader(title: title, question: question)

            ForEach(store.options.indices) { id in
                MultipleTextSelectionCell(option: $store.options[id])
            }

            Spacer()

            Button(action: store.submit) {
                HStack {
                    Spacer()
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(Color.blue)
                .cornerRadius(24)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!store.canSubmit)
            .padding()
        }
    }
}

struct MultipleAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MultipleAnswerQuestionTestView()

            MultipleAnswerQuestionTestView()
                .preferredColorScheme(.dark)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }

    struct MultipleAnswerQuestionTestView: View {
        @State var selection = ["none"]

        var body: some View {
            VStack {
                MultipleAnswerQuestion(
                    title: "1 of 2",
                    question: "What's Mike's nationality?",
                    store: .init(
                        options: [
                            "Portuguese",
                            "American",
                            "Greek",
                            "Canadian"
                        ],
                        handler: { selection = $0 }
                    )
                )

                Text("Last submission: " + selection.joined(separator: ", "))
            }
        }
    }
}
