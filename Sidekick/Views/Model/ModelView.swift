//
//  ModelView.swift
//  Sidekick
//
//  Created by John Bean on 2/18/25.
//

import DefaultModels
import SwiftUI

struct ModelView: View {
	
	var model: HuggingFaceModel
	
	var paramsDescription: String {
		let count: Float = round(model.params * 10.0) / 10
		if Float(Int(count)) == count {
			return "\(Int(count))"
		}
		return "\(count)"
	}
	
	var benchmarkDescription: String {
		return "\(round(model.mmluScore * 10.0) / 10)"
	}
	
    var body: some View {
		VStack(
			alignment: .leading,
			spacing: 7
		) {
			Text(model.name)
				.font(.headline)
				.bold()
			properties
			Spacer()
			HStack {
				Spacer()
				Button(action: download) {
					Text("Download")
				}
				.controlSize(.large)
			}
		}
		.padding()
		.background(
			alignment: .top
		) {
			RoundedRectangle(cornerRadius: 7)
				.fill(Color.secondary.opacity(0.2))
				.frame(minHeight: 150, maxHeight: 200)
		}
    }
	
	var properties: some View {
		Group {
			Text("Parameters: \(paramsDescription)B")
			Text("Benchmark Score (MMLU): \(benchmarkDescription)")
			specializations
		}
		.font(.subheadline)
		.foregroundStyle(.secondary)
	}
	
	var specializations: some View {
		ScrollView {
			HStack {
				ForEach(
					self.model.specializations,
					id: \.self
				) { specialty in
					SpecialtyView(specialty: specialty)
				}
			}
		}
	}
	
	private func download() {
		// Check if can run, and confirm with user
		if !model.canRun() {
			let didConfirm: Bool = Dialogs.dichotomy(
				title: String(localized: "Requirements"),
				message: String(localized: "Due to limited hardware specifications, you may suffer from degraded performance when running this model. ") + String(localized: "Are you sure you want to continue?"),
				option1: String(localized: "Yes"),
				option2: String(localized: "No"),
				ifOption1: {},
				ifOption2: {}
			)
			// If aborted, exit
			if !didConfirm {
				return
			}
		}
		// Start download
		Task.detached { @MainActor in
			await DownloadManager.shared.downloadModel(
				model: model
			)
		}
		// Show in progress
		Dialogs.showAlert(
			title: String(localized: "Downloading"),
			message: String(localized: "Downloading \(model.name). When complete, the model will be available for selection in `Settings -> Inference`.")
		)
	}
	
}
