# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'Pharmacy' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Codegen
    pod 'R.swift'
    
  # Pods for Pharmacy
  pod 'Alamofire', '~> 5.2'
  pod 'EventsTree'
  pod 'Moya', '~> 14.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'GoogleMaps'
  pod 'TPKeyboardAvoiding'
  pod 'MessageKit'
  pod 'LDSwiftEventSource', '~> 1.2'
  pod 'Firebase/Messaging'
  pod 'IQKeyboardManager'
  pod 'SVGKit'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
