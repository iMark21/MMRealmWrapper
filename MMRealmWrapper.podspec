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
s.ios.deployment_target = '9.0'
s.name = "MMRealmWrapper"
s.summary = "An easy way to manage your Realm Database with Swift"
s.requires_arc = true

# 2
s.version = "0.2.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Míchel Marqués" => "marques.jm@icloud.com" }

# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://twitter.com/michelmarques21"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/iMark21/MMRealmWrapper", :tag => s.version}

# 7
s.dependency 'RealmManager', '~> 1.0.8'

# 8
s.source_files = 'MMRealmWrapper/Classes/**/*.{swift}'

end
