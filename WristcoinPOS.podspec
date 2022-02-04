#
# Be sure to run `pod lib lint WristcoinPOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WristcoinPOS'
  s.version          = '0.1.0'
  s.summary          = 'Integrate WristCoin Cashless Payments into your Point of Sale application'

  s.description      = <<-DESC
  This pod is an SDK to allow POS vendors to integrate WristCoin contactless cashless payments and accept WristCoin wallets as a form of payment.
                       DESC

  s.homepage         = 'https://github.com/WristCoin/POS-Integration-SDK-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'dshalaby' => 'dave@mywristcoin.com' }
  s.source           = { :git => 'https://github.com/WristCoin/POS-Integration-SDK-iOS.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/mywristcoin'

  s.ios.deployment_target = '12.0'
  s.swift_versions = '4.2'

  s.source_files = 'WristcoinPOS/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WristcoinPOS' => ['WristcoinPOS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'TCMPTappy'
  s.dependency 'SwiftTLV'
end
