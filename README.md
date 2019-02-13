# ReactNative-NativeCameraIOS-Template
template for creating a NativeCamera in IOS to be bridged on react-native

NativeCamera module developed in swift

# instructions
1. copy the CameraModuleManager.swift and CameraModuleManager.m file from the ios code folder to your ios folder in the react-native project 
2. open XCode and add the files CameraModuleManager.swift and CameraModuleManager.m on your project structure
3. XCode will prompt to create bridge header .h file
4. open SampleProjectCamera-Bridging-Header.h file in ios code folder and copy the imports and paste it to your header project
5. copy the folder NativeCameraModule that contains the js file and paste it to your root project
6. import component to your app.js and use it

you can view the example on SampleProjectCamera Folder

