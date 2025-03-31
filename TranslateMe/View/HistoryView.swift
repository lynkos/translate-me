//
//  HistoryView.swift
//  TranslateMe
//
//  Created by Kiran Brahmatewari on 3/29/25.
//

import SwiftUI

struct HistoryView: View {
    @State var translationManager: TranslationManager = TranslationManager()
    
    var body: some View {
        VStack {
            historyContents
            clearButton            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.backgroundColor)
    }
        
    @ViewBuilder
    private var historyContents: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(translationManager.translations) { translation in
                        Text(translation.translatedText)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Constants.textBoxColor)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Constants.accentColor, lineWidth: 1 / 4)
                            )
                            .foregroundColor(Constants.foregroundColor)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                    }
                }
                .padding(.vertical, 5)
                .listRowSeparator(.hidden)
            }
            .background(Color.clear)
            .scrollContentBackground(.hidden)
            
        }
        .background(Color.clear)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var clearButton: some View {
        Button(action: {
            translationManager.clearTranslations()
        }) {
            Text("Clear All Translations")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color.red.gradient)
                .foregroundColor(Color.white)
                .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}

#Preview {
    HistoryView()
}
