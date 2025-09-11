//
//  Report.swift
//  MovieApp
//
//  Created by adithyan na on 7/9/25.
//

import Foundation
import SwiftUI
struct BugReportView: View {
    @Environment(\.presentationMode) var dismiss
    @State private var description = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Describe the bug")) {
                    TextEditor(text: $description)
                }
            }
            .navigationTitle("Report a Bug")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") {
                        // Integrate with your feedback API or mail composer
                        dismiss.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss.wrappedValue.dismiss() }
                }
            }
        }
    }
}
