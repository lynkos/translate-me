//
//  TranslationManager.swift
//  TranslateMe
//
//  Created by Kiran Brahmatewari on 3/30/25.
//

import Foundation
import FirebaseFirestore

@Observable
class TranslationManager {
    var translations: [Translation] = []
    private let dataBase = Firestore.firestore()
    
    init() {
        getTranslations()
    }
        
    func clearTranslations() {
        dataBase.collection("translations").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            for document in snapshot?.documents ?? [] {
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting document \(document.documentID): \(error)")
                    } else {
                        print("Document \(document.documentID) successfully deleted!")
                    }
                }
            }
            
            self.translations.removeAll()
        }
    }
    
    func getTranslations() {
        dataBase.collectionGroup("translations").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching translations: \(String(describing: error))")
                return
            }
            
            let translations = documents.compactMap { document in
                do {
                    return try document.data(as: Translation.self)
                } catch {
                    print("Error decoding document into message: \(error)")
                    return nil
                }
            }
            
            self.translations = translations
        }
    }
    
    func addTranslation(text: String) {
        do {
            let translation = Translation(id: UUID().uuidString, translatedText: text)
            try dataBase.collection("translations").document().setData(from: translation)
        } catch {
            print("Error sending message to Firestore: \(error)")
        }
    }
}
