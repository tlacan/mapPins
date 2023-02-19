# Map Pins

<p align="center">
<img width="200" height="200" src="https://github.com/tlacan/mapPins/raw/main/MapPins/MapPins/resources/launch%402x.png">
</p>

This is a sample iOS project made in SwiftUI. </br>

It is compatible on iPads and iPhones for iOS 16/15.</br>

Following youtube "courses" videos related to the project are available:
[Course1](https://youtu.be/Z6WVdMY8mPo)
[Course2](https://youtu.be/s34QGSDyyA0)


If I have more time, I may release other videos for the complete project (and may add features).

## Architecture

<img src="https://raw.githubusercontent.com/tlacan/mapPins/main/archi.png">

Inspired by [https://nalexn.github.io/clean-architecture-swiftui/](https://nalexn.github.io/clean-architecture-swiftui/)

## SwiftUI Views
Global app UI properties are stored in AppConstants.
View specific constants are stored in SwiftUI ViewConstants.
If needed Views have a body16 function to manage content specific for iOS 16 and
a body15 for content specific to iOS15.
In case of future release and will be very easy to get rid of old code and remove deprecated SwiftUI code.

#### Navigation
Navigation is managed differently for iOS16 (NavigationStack) and iOS15 (Navigation View). "Links" to push view are also managed differently depending iOS version. 

NB: For iPad on iOS 15 must use navigationViewStyle stack

### Text
Text string are localized and managed with Swiftgen to avoid typing errors or deleted entries. Text styles are managed in TextViews and accessible from String.

### Images
Images accessors are generated with SwiftGen, images are reduced for pngs using ImageOptim. Symbols images can be accessed with SFSafeSymbols enums. A convinient function fit, helps to render fit image at the right size and color.

### Buttons
Different buttons are available in Views/Components folder. 
Main one is ButtonView, add different styles in it if needed.

## Librairies
The project use the following Swift Packages.
#### SwiftLint
Make sure code standard and quality are respected.
See youtube video if needed to see configuration in project. </br>
[https://github.com/realm/SwiftLint](https://github.com/realm/SwiftLint)

#### SwiftGen
Generate convinient enums to access project ressources. Lotties file, localized strings, Images, Colors and fonts.
See youtube video 1 if needed to see configuration in project. </br>
[https://github.com/SwiftGen/SwiftGen](https://github.com/SwiftGen/SwiftGen)

#### Lottie
Run lottie animation, convinient SwiftUI wrapper has been done in the project. </br>
[https://github.com/airbnb/lottie-ios](https://github.com/airbnb/lottie-ios)

#### Stores
A solution to store Codable in any possible ways and it abstract all complexity. </br> 
[https://github.com/omaralbeik/Stores](https://github.com/omaralbeik/Stores)

#### Introspect
Help to access UIKit components from SwiftUI views, still needed to customise some UI, specially on iOS 15. </br>
[https://github.com/siteline/SwiftUI-Introspect.git](https://github.com/siteline/SwiftUI-Introspect.git)

#### StarRating
SwiftUI view to help managing star rating with star shapes customizable. </br>
[https://github.com/dkk/StarRating](https://github.com/dkk/StarRating)

#### ImagePickerView
Convinient swiftUI Image picker helper for iOS15 only.</br>
[https://github.com/dkk/StarRating](https://github.com/dkk/StarRating)

#### PartialSheet
Helper to manage presentation sheet detent in SwiftUI for iOS 15.</br>
[https://github.com/AndreaMiotto/PartialSheet](https://github.com/AndreaMiotto/PartialSheet)

#### AckGen
Acknolegement UI + plist management for Swift Packages use in the project.</br>
[https://github.com/MartinP7r/AckGen](https://github.com/MartinP7r/AckGen)

#### AckGen
Acknolegement UI + plist management for Swift Packages use in the project.</br>
[https://github.com/MartinP7r/AckGen](https://github.com/MartinP7r/AckGen)

#### SwiftDate
Helpers for Date and Time operations.</br>
[https://github.com/malcommac/SwiftDate](https://github.com/malcommac/SwiftDate)

#### Neumorphic
Helper to make inner shaddow Neumorphic style in iOS15.</br>
[https://github.com/costachung/neumorphic](https://github.com/costachung/neumorphic)

#### SFSafeSymbols
Safe enum accessors to SF symbols.</br>
[https://github.com/SFSafeSymbols/SFSafeSymbols](https://github.com/SFSafeSymbols/SFSafeSymbols)

Feel free to contact me, if you have any questions,comment you are welcome:
[lacan.thomas.pro@gmail.com](mailto:lacan.thomas.pro@gmail.com)



