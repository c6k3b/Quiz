// Copyright © 2023 aa. All rights reserved.

struct MultipleSelectionStore {
	var options: [MultipleSelectionOption]
	var canSubmit: Bool { !options.filter(\.isSelected).isEmpty }
	private let handler: ([String]) -> Void
	
	internal init(options: [String], handler: @escaping ([String]) -> Void) {
		self.options = options.map { MultipleSelectionOption(text: $0) }
		self.handler = handler
	}
	
	func submit() {
		guard canSubmit else { return }
		handler(options.filter(\.isSelected).map(\.text))
	}
}
	
struct MultipleSelectionOption {
	let text: String
	var isSelected = false
	
	mutating func toggleSelection() {
		isSelected.toggle()
	}
}
