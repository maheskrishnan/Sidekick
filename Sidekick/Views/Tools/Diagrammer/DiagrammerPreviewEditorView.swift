//
//  DiagrammerPreviewEditorView.swift
//  Sidekick
//
//  Created by John Bean on 2/20/25.
//

import SwiftUI
import CodeEditorView
import LanguageSupport

struct DiagrammerPreviewEditorView: View {
	
	@Environment(\.dismissWindow) private var dismissWindow
	@Environment(\.colorScheme) private var colorScheme: ColorScheme
	@EnvironmentObject private var diagrammerViewController: DiagrammerViewController
	
	@State private var position: CodeEditor.Position = CodeEditor.Position()
	@State private var messages: Set<TextLocated<LanguageSupport.Message>> = Set()
	
    var body: some View {
		HSplitView {
			editor
				.frame(minWidth: 300)
			ZStack {
				Rectangle()
					.fill(Color.clear)
					.frame(width: 1, height: .greedy)
				self.diagrammerViewController.preview
			}
			.frame(minWidth: 300)
		}
		.toolbar {
			ToolbarItemGroup(
				placement: .primaryAction
			) {
				newButton
				saveButton
				exitButton
			}
		}
    }
	
	var editor: some View {
		CodeEditor(
			text: self.$diagrammerViewController.d2Code,
			position: self.$position,
			messages: self.$messages
		)
		.environment(
			\.codeEditorTheme, colorScheme == .dark ? Theme.defaultDark : Theme.defaultLight
		)
		.onChange(of: diagrammerViewController.d2Code) {
			self.diagrammerViewController.saveD2Code()
		}
	}
	
	var saveButton: some View {
		Button {
			self.saveDiagram()
		} label: {
			Text("Save")
		}
		.keyboardShortcut("s", modifiers: [.command])
		.controlSize(.large)
	}
	
	var newButton: some View {
		Button {
			// Reset to exit to prompt view
			self.resetDiagram()
		} label: {
			Text("New Diagram")
		}
	}
	
	var exitButton: some View {
		Button {
			// Reset
			self.resetDiagram()
			// Close window
			self.dismissWindow(id: "diagrammer")
		} label: {
			Text("Exit")
		}
		.controlSize(.large)
	}
	
	private func resetDiagram() {
		self.diagrammerViewController.stopRender()
		self.diagrammerViewController.stopPreview()
		self.diagrammerViewController.d2Code = ""
		self.diagrammerViewController.saveD2Code()
		self.diagrammerViewController.currentStep = .prompt
	}
	
	private func saveDiagram() {
		// Save image
		let saveSuccess: Bool = self.diagrammerViewController.saveImage()
		let message: String = saveSuccess ? String(localized: "Diagram saved successfully") : String(localized: "Failed to save diagram")
		// Show dialog
		Dialogs.showAlert(title: "Save", message: message)
	}
	
}
