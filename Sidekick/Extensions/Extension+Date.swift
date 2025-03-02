//
//  Extension+Date.swift
//  Sidekick
//
//  Created by John Bean on 3/2/25.
//

import Foundation

public extension Date {
	
	/// A `String` representing the current date
	var dateString: String {
		return String(
			self.description.split(separator: " ").first ?? Substring(self.description)
		)
	}
	
}
