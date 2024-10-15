//
//  SettingsView.swift
//  Sidekick
//
//  Created by Bean John on 10/14/24.
//

import SwiftUI

struct SettingsView: View {
	
    var body: some View {
		Group {
			if #available(macOS 15, *) {
				TabView {
					Tab(
						"General",
						systemImage: "gear"
					) {
						GeneralSettingsView()
					}
					Tab(
						"Inference",
						systemImage: "brain.fill"
					) {
						InferenceSettingsView()
					}
				}
			} else {
				TabView {
					GeneralSettingsView()
						.tabItem {
							Label(
								"General",
								systemImage: "gear"
							)
						}
					InferenceSettingsView()
						.tabItem {
							Label(
								"Inference",
								systemImage: "brain.fill"
							)
						}
				}
			}
		}
		.frame(maxWidth: 600)
		.padding()
    }
	
}

#Preview {
    SettingsView()
}
