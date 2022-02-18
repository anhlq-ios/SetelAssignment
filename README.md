# SetelAssignment
SetelAssignment using MVVM architect, track if user is in specific locations

Associate with wifi network is not available at this moment. Because I don't have a developer account so I can't grant Wifi Access Information capabilities for the app.

## **1. Architecture**
It's written in MVVM. It's quite similar to the traditional version, just that using communicate protocols helps us make the responsibility clearer, easy to test and scale up.

## **2. Code structure**

SetelAssignment
This consists of files being used in the main target.

- Configs: Configs file, Constants...
- Coordinator: Contains Coordinators responsible for routing in app
- Models: Declare the models/entities used in the app.
- Persistent: Persistant storage to handle local DB.
- Services: Service managers such as location, network.
- Screens: Every screen's MVVM components are located in this folder.
- Resouces: Assets image, icon...

- LocalPods
The libs that can be shared between the main target and unit/UI test target are located in LocalPods such as RxSwift, RxCocoa

## **3. Third-party libraries**
Below is the list of third-party libraries that I use in the project:

- **RxSwift/RxCocoa**: It is this project's backbone to seamlessly manipulate UI events (binding between ViewModel and View) as well as API requests/responses. By transforming everything to a sequence of events, it not only makes the logic more understandable and concise but also helps us get rid of the old approach like adding target, delegates, closures which we might feel tedious sometimes.

## **4. Build the project on local**
- After cloning the repo, please run `pod install` from your terminal then open `SetelAssignment.xcworkspace` and try to build the project using Xcode 12+.
It should work without any additional steps.

## **5. Checklist**
- [x] Programming language: Swift

- [x] Design app's architecture: MVVM
 
- [ ] Unit tests

Thanks and have a nice day!
