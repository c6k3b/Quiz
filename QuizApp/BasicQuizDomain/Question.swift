// Copyright © 2023 aa. All rights reserved.

public enum Question<T: Hashable>: Hashable {
	case singleAnswer(T)
	case multipleAnswer(T)
}
