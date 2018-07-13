#
#  Be sure to run `pod spec lint libRyze.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "libRyze"
  s.version      = "1.0.0"
  s.summary      = "libRyze 是使用对Aspects的封装."
  s.description  = <<-DESC
                      this project provide Aspects libs 
                   DESC

  s.homepage     = "https://github.com/Alittlefly/Ryze"
  # s.license      = "MIT (gaochao)"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "gaochao" => "1176672158@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Alittlefly/Ryze.git", :tag => "1.0.0" }
  s.source_files  = "Classes", "libRyze/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.frameworks  = "UIKit","Foundation"


  s.dependency  "Aspects"
  # s.dependency  "FMDB"
  # s.dependency  "MJExtension"
  # s.dependency  "LKDBHelper"
  # s.dependency "MJExtension", "FMDB","LKDBHelper","Aspects"

end
