//  SingleAnswerQuestion.swift
//  Created by aa on 1/18/23.

import SwiftUI

struct SingleAnswerQuestion: View {
    let title: String
    let question: String
    let options: [String]
    let selection: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            VStack(alignment: .leading, spacing: 16.0) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.blue)
                    .padding(.top)

                Text(question)
                    .font(.largeTitle)
                    .fontWeight(.medium)
            }.padding()

            ForEach(options, id: \.self) { option in
                Button(action: {}) {
                    HStack {
                        Circle()
                            .stroke(Color.secondary, lineWidth: 2.5)
                            .frame(width: 40.0, height: 40.0)

                        Text(option)
                            .font(.largeTitle)
                            .foregroundColor(.secondary)

                        Spacer()
                    }.padding()
                }
            }

            Spacer()
        }

    }
}

struct SingleAnswerQuestion_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SingleAnswerQuestion(
                title: "1 of 2",
                question: "What's Mike's nationality?",
                options: [
                    "Portuguese",
                    "American",
                    "Greek",
                    "Canadian"
                ],
                selection: { _ in }
            )


            SingleAnswerQuestion(
                title: "1 of 2",
                question: "What's Mike's nationality?",
                options: [
                    "Portuguese",
                    "American",
                    "Greek",
                    "Canadian"
                ],
                selection: { _ in }
            )
            .preferredColorScheme(.dark)
            .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }
}
