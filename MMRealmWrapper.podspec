#
#  Be sure to run `pod spec lint MMRealmWrapper.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

# 1
s.platform = :ios
s.swift_version = '4.0'
s.ios.deployment_target = '9.0'
s.name = "MMRealmWrapper"
s.license = { :type => 'MIT', :file => 'LICENSE' }
s.summary = "An easy way to manage your Realm Database with Swift"
s.requires_arc = true
s.version = "0.3.8"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Míchel Marqués" => "marques.jm@icloud.com" }
s.homepage = "https://twitter.com/michelmarques21"
s.source = { :git => "https://github.com/iMark21/MMRealmWrapper.git", :tag => s.version}
s.dependency 'RealmManager', '~> 1.0.9'
s.source_files = 'MMRealmWrapper/**/*.swift'

end
