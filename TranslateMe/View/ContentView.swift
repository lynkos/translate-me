//
//  ContentView.swift
//  TranslateMe
//
//  Created by Kiran Brahmatewari on 3/29/25.
//

import SwiftUI

struct ContentView: View {
    @State var translationManager: TranslationManager = TranslationManager()
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var showHistory: Bool = false
    @State private var selectedFromLanguage = "English"
    @State private var selectedToLanguage = "Spanish"
    private let translationPlaceholder: String = "Translating..."
    
    private let languages: [String: String] = [
        "Arabic": "ar",
        "Chinese": "zh",
        "Czech": "cs",
        "Danish": "da",
        "Dutch": "nl",
        "English": "en",
        "Finnish": "fi",
        "French": "fr",
        "German": "de",
        "Greek": "el",
        "Hebrew": "he",
        "Hindi": "hi",
        "Hungarian": "hu",
        "Italian": "it",
        "Japanese": "ja",
        "Korean": "ko",
        "Norwegian": "no",
        "Polish": "pl",
        "Portuguese": "pt",
        "Romanian": "ro",
        "Russian": "ru",
        "Spanish": "es",
        "Swedish": "sv",
        "Thai": "th",
        "Turkish": "tr",
        "Vietnamese": "vi"
    ]
                  
    private func fetchTranslation(for input: String) async {
        // If input is empty, don't fetch translation and clear translated text view to reflect empty input
        if input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.translatedText = ""
            return
        }
        
        let translateFrom: String = languages[selectedFromLanguage] ?? "en"
        let translateTo: String = languages[selectedToLanguage] ?? "es"

        guard let url = URL(string: "https://api.mymemory.translated.net/get?q=\(input)&langpair=\(translateFrom)|\(translateTo)") else {
            print("Invalid URL")
            return
        }
        
        DispatchQueue.main.async {
            self.translatedText = translationPlaceholder
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let translationResponse = try JSONDecoder().decode(TranslationResponse.self, from: data)
            let translationText = translationResponse.responseData.translatedText
            
            DispatchQueue.main.async {
                self.translatedText = translationText
                self.translationManager.addTranslation(text: translationText)
            }
        } catch {
            print("Error fetching translation:", error)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                languagePickers
                inputField
                translateButton
                outputField
                historyButton
            }
            .padding()
            .navigationBarTitle("Translate Me", displayMode: .large)
            .toolbarBackground(Constants.backgroundColor, for: .navigationBar)
            .background(Constants.backgroundColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var inputField: some View {
        TextEditor(text: $inputText)
            .padding(10)
            .foregroundColor(Constants.foregroundColor)
            .font(.custom("HelveticaNeue", size: 17))
            .disableAutocorrection(true)
            .scrollContentBackground(.hidden)
            .background(Constants.textBoxColor.cornerRadius(20))
            .overlay(
                Group {
                    if inputText.isEmpty {
                        Text("Enter text to translate here...")
                            .foregroundColor(Color.gray)
                            .padding()
                    }
                }, alignment: .topLeading
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Constants.foregroundColor, lineWidth: 1 / 4)
            )
    }
    
    @ViewBuilder
    private var outputField: some View {
        TextEditor(text: Binding(
            get: { translatedText },
            set: { newValue in translatedText = newValue }))
        .padding(10)
        .foregroundColor(self.translatedText == translationPlaceholder ? Color.gray : Constants.foregroundColor)
        .font(.custom("HelveticaNeue", size: 17))
        .disableAutocorrection(true)
        .scrollContentBackground(.hidden)
        .background(Constants.textBoxColor.cornerRadius(20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Constants.foregroundColor, lineWidth: 1 / 4)
        )
    }
    
    @ViewBuilder
    private var languagePickers: some View {
        VStack {
            HStack {
                // Translate from
                VStack {
                    Text("From")
                        .font(.subheadline)
                        .bold()
                    Picker("From", selection: $selectedFromLanguage) {
                        ForEach(languages.keys.sorted(), id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Constants.accentColor)
                    
                }
                .frame(maxWidth: .infinity)
                
                // Swap languages button
                Button(action: {
                    swap(&selectedFromLanguage, &selectedToLanguage)
                }) {
                    Image(systemName: "arrow.left.arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Constants.accentColor)
                        .padding()
                }
                
                // Translate to
                VStack {
                    Text("To")
                        .font(.subheadline)
                        .bold()
                    Picker("To", selection: $selectedToLanguage) {
                        ForEach(languages.keys.sorted(), id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(Constants.accentColor)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
        
    @ViewBuilder
    private var translateButton: some View {
        Button(action: {
            Task {
                await fetchTranslation(for: inputText)
            }
        }) {
            Text("Translate Me")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Constants.translateButtonColor)
                .foregroundColor(Color.white)
                .clipShape(Capsule())
        }
    }
    
    @ViewBuilder
    private var historyButton: some View {
        Button(action: {
            showHistory = true
        }) {
            Text("View Saved Translations")
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(Constants.accentColor)
        }
        .navigationDestination(isPresented: $showHistory) {
            HistoryView()
        }
    }
}

#Preview {
    ContentView()
}
