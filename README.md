# Project 6 - *TranslateMe*
iOS app that translates between languages and allows users to store and delete their translations.

## Features
- [x] Users open the app to a TranslationMe home page with a place to enter a word, phrase or sentence, a button to translate, and another field that should initially be empty
- [x] When users tap translate, the word written in the upper field translates in the lower field; you can only translate from one language to another
- [x] A history of translations can be stored (in a scroll view in the same screen, or a new screen)
- [x] The history of translations can be erased
- [x] Add a variety of choices for the languages
- [x] Add UI flair
- [x] Add button to conveniently switch languages

## Demo
<div>
    <a href="https://www.loom.com/share/8201c699706640cdb368abc693a09d38">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/8201c699706640cdb368abc693a09d38-7c685253a31533a9-full-play.gif">
    </a>
  </div>

## Setup
Firebase Firestore is used for the backend (to store the translations), which needs to be setup beforehand.

1. Go to [Firebase](https://firebase.google.com) and click "[Get Started](https://console.firebase.google.com)"
2. Click "Create a Firebase project"
3. Enter the name of your project and click "Continue"
4. Disable "Enable Gemini in Firebase"
5. Disable "Enable Google Analytics", and click "Create project"
6. From your new Firebase project overview page, in the Get started by adding Firebase to your app section, click the iOS+ / Apple button
7. Copy the Bundle Identifier from your Xcode app
8. Paste the Apple bundle ID (from your Xcode project app)
9. Click the Register app button to continue
10. Move the `GoogleService-Info.plist` file you just downloaded into the root of your Xcode project
11. (Back in Firebase) Click the Next button
12. Use Swift Package Manager to install and manage Firebase dependencies by navigating to `File > Add Package Dependencies`
13. Remove unnecessary frameworks. You only need `FirebaseAuth` and `FirebaseFirestore`. (Select all of the other frameworks that were embedded and use the (**-**) button to remove them. If you accidentally remove a framework you need, you can use the (**+**) button to add it back)
14. (Back in Firebase) Click the Next button
15. From your Firebase console for the app you created, in the Choose a product to add to your app section, click Cloud Firestore Cloud Firestore
16. Click Create database
17. Set name an location: Leave the default selections and click the Next button
18. Secure rules: Leave the default selections and click the Next button (you'll update the rules in a later step)
19. From the Cloud Firestore page, click the Rules menu
20. Replace the rules snippet with the following snippet. This will allow any user to read and write to your database.
```
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read and write access to the 'translations' collection
    match /translations/{document=**} {
      allow read, write: if true; // This allows both read and write access for all users
    }
  }
}
```

> [!TIP]
> This is a rule for all authenticated users
> ```
> rules_version = '2';
> 
> service cloud.firestore {
>   match /databases/{database}/documents {
> 
>     // All authenticated users
>     // https://firebase.google.com/docs/rules/basics?authuser=0#all_authenticated_users
>     match /{document=**} {
>       allow read, write: if request.auth != null;
>     }
>   }
> }
> ```

21. Click the Publish button

## License
    Copyright 2025 Kiran Brahmatewari

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
