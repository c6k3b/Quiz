// Copyright © 2023 aa. All rights reserved.

import BasicQuizDomain

let demoQuiz = try!
	BasicQuizBuilder(
		singleAnswerQuestion: "What's Mike's nationality?",
		options: ["Canadian", "American", "Greek"],
		answer: "Greek"
	)
	.adding(
		multipleAnswerQuestion: "What are Caio's nationalities?",
		options: ["Portuguese", "American", "Brazilian"],
		answer: ["Portuguese", "Brazilian"]
	)
	.adding(
		singleAnswerQuestion: "What's the capital of Brazil?",
		options: ["Sao Paolo", "Rio de Janeiro", "Brasilia"],
		answer: "Brasilia"
	)
	.build()
