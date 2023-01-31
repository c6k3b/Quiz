// Copyright © 2023 aa. All rights reserved.

import BasicQuizDomain

let demoQuiz = try!
	BasicQuizBuilder(
		singleAnswerQuestion: "What year was the very first model of the iPhone released?",
		options: ["2006", "2007", "2008"],
		answer: "2007"
	)
	.adding(
		multipleAnswerQuestion: "Which two months are named after Emperors of the Roman Empire?",
		options: ["March", "July", "August"],
		answer: ["July", "August"]
	)
	.adding(
		singleAnswerQuestion: "Who is often called the father of the computer?",
		options: ["Charles Babbage", "Alan Turing"],
		answer: "Charles Babbage"
	)
	.build()
