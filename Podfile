# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'StockAPI' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for StockAPI
  pod 'Swinject'
  pod 'SwinjectStoryboard'
  pod 'SwiftLint'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxSwiftExt'
  pod 'Moya/RxSwift', '~> 14.0'
  pod 'Charts'
  pod 'DropDown'
  
  target 'StockAPITests' do
    inherit! :complete
    # Pods for testing
  end

  target 'StockAPIUITests' do
    # Pods for testing
  end
  
  post_install do |pi|
      pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
      end
  end

end
