// Copyright © 2023 aa. All rights reserved.

import SwiftUI

struct ResultAnswerCell: View {
	let model: PresentableAnswer

	var body: some View {
		VStack(alignment: .leading, spacing: 0.0) {
			Text(model.question)
				.font(.title)
			
			Text(model.answer)
				.font(.title2)
				.foregroundColor(.green)
			
			if let wrongAnswer = model.wrongAnswer {
				Text(wrongAnswer)
					.font(.title2)
					.foregroundColor(.red)
			}
		}
		.padding(.vertical)
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
		}
		.previewLayout(.sizeThatFits)
	}
}
