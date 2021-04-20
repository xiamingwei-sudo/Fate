#
# Be sure to run `pod lib lint Fate.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Fate'
  s.version          = '0.1.4'
  s.summary          = '公共组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
公共组件库,封装了一些协助开发的公共组件
                       DESC

  s.homepage         = 'https://github.com/xiamingwei-sudo/Fate'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'XiaMingWei' => 'xiamwei@hotmail.com' }
  s.source           = { :git => 'https://github.com/xiamingwei-sudo/Fate.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.frameworks = "Foundation"
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.swift_version= '5.0'
 
   s.subspec "Logger" do |ls|
    ls.source_files = "Fate/Classes/Logger"
  end
  
  s.subspec "Logs" do |ls|
    ls.source_files = "Fate/Classes/Logs"
    ls.dependency "XCGLogger", '~> 7.0.0'
  end
  
  s.subspec "RxCocoaHelper" do |rs|
    rs.source_files = "Fate/Classes/RxCocoahelper/**/*"
    rs.dependency "RxSwift"
    rs.dependency "RxCocoa"
    rs.dependency "RxSwiftExt"
    rs.dependency "MJRefresh"
    rs.dependency "NSObject+Rx"
    rs.dependency "Fate/Namespacer"
#    rs.dependency "MWNamespacer"
  end
  
  s.subspec "Mediator" do |ms|
    ms.source_files = "Fate/Classes/Mediator/**/*"
    ms.public_header_files = "Fate/Classes/Mediator/Supports/*.h"
  end
  
  s.subspec "Autolayout" do |as|
    as.source_files = "Fate/Classes/Autolayout/**/*"
  end

  s.subspec "SwiftyPing" do |ss|
    ss.source_files = "Fate/Classes/SwiftyPing/**/*"
  end
  s.subspec "AutoInch" do |sa|
    sa.source_files = "Fate/Classes/AutoInch/**/*"
  end
   
  s.subspec "SwiftyEx" do |sse|
    sse.source_files = "Fate/Classes/SwiftyEx/**/*"
    rs.dependency "Fate/Namespacer"
#    sse.dependency "MWNamespacer"
  end
  
  s.subspec "LocationManager" do |sl|
    sl.source_files = "Fate/Classes/LocationManager/**/*"
    sl.public_header_files = "Fate/Classes/LocationManager/*.h"
  end
  
  s.subspec "ObjectExtension" do |oe|
    oe.source_files = "Fate/Classes/ObjectExtension/**/*"
    oe.public_header_files = "Fate/Classes/ObjectExtension/*.h"
    oe.dependency "GTMBase64"
  end
  s.subspec "Namespacer" do |oe|
    oe.source_files = "Fate/Classes/Namespacer/**/*"
  end
  
  
   
end
