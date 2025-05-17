source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '16.0'

use_frameworks!
inhibit_all_warnings!

#------ TARGET --------

target 'App' do
  pod 'SwiftLint', '0.44.0'
end

#------ ETC --------

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
        config.build_settings["DEVELOPMENT_TEAM"] = "Q4849T729U"
        config.build_settings['ENABLE_BITCODE'] = 'NO'

        next unless config.name == 'Release'

        # cocoapods defaults to not stripping the frameworks it creates
        config.build_settings['STRIP_INSTALLED_PRODUCT'] = 'YES'
      end
    end
  end
end
