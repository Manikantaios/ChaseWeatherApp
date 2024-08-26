//
//  SearchToolBarView.swift
//  WeatherAppChase
//

import SwiftUI

struct SearchToolBarView: View {
    @State var searchText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    let onSearch: (String) -> Void // Callback for search action

    var body: some View {
            HStack {
                TextField("Enter City name or ZIP code", text: $searchText, onCommit: {
                    performSearch()
                })
                .padding(8)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1) // Light border
                )
                .focused($isTextFieldFocused)
                .transition(.opacity) // Fade in/out effect
                .animation(.easeInOut(duration: 0.3), value: searchText)
                
              //  Spacer()
                // Always visible Search Button
                Button(action: {
                    performSearch()
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical, 10)
            .onChange(of: isTextFieldFocused) {
                if !isTextFieldFocused {
                    searchText = "" // Clear the text field when focus is lost
                }
            }
            .onDisappear {
                searchText = "" // Clear the text field when view disappears
                isTextFieldFocused = false // Dismiss the keyboard
            }
        
    }
    
    private func performSearch() {
        // Perform the search action
        onSearch(searchText) // Pass the search text
        searchText = "" // Clear the text field
        isTextFieldFocused = false // Dismiss the keyboard
    }
}

#Preview {
    SearchToolBarView(onSearch: { _ in
        
    })
    .background(.red)
}
