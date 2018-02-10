# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'Alamofire', '~> 4.5'
  pod 'SDWebImage'
  pod 'SwiftyJSON'
  pod 'PromiseKit/Alamofire', '~> 4.0'
  pod 'SnapKit', '~> 4.0.0'
  pod 'FontAwesome.swift'
  pod 'MagicalRecord'
  pod 'DGActivityIndicatorView'
  pod 'MBProgressHUD', '~> 1.1.0'
  pod 'SwipeCellKit'
  pod 'KeychainAccess'
  pod 'DZNEmptyDataSet'
 
end

target 'FileSharer' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  # Pods for FileSharer
  shared_pods
  pod 'Tabman', '~> 1.0'
end

target 'MobileSafariEnhancer' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  shared_pods
  pod 'Material'
  pod "GCDWebServer/WebDAV", "~> 3.0"
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.0'
      end
  end
end
