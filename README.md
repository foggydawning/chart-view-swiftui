# chart-view-swiftui
Chart view implemented via SwiftUI + MVVM + Combine. DB - Realm

![til](./gifs/screenshot-1)

## Project Description
The project is a View that allows you to REPRODUCE data in the format (Date, Int), combined into groups.

## Installation instructions 
1. Download the repository file. 
2. Using the terminal, go to the directory of the downloaded file. 
3. Execute commands:
  - cd chart-view-swiftui 
  - pod install
4. Open the file that appears in the extension.xcworkspace

## Important! When using! 🌹🌹🌹
Since View is not designed to write data to the database, I have added some functions that will add data to the database just for demonstration. If you want to use this View, delete the lines marked with the comment "start Block ONLY FOR A TEST" and "end Block ONLY FOR A TEST" and the extension marked "Test Data ONLY FOR A TEST" in the file /chart-view-swiftui/ViewModel/ChartViewModel
You can also delete the file chart-view-swiftui/Realm/TestData

## Opening DB
The realm file can be opened using MongoDBRealmStudio and it directories can be found at the path: 
    /Users/<username>/Library/Developer/CoreSimulator/Devices/<simulator-uuid>/data/Containers/Data/Application/<application-uuid>/Documents/
