Pod::Spec.new do |s|
  s.name         = "bFSwift"
  s.version      = "0.0.1"
  s.summary      = "bitFlyer Lightning API wrapper for Swift"
  s.description  = <<-DESC
                   For easy access to bitFlyer Lightning APIs from Swift
                   DESC
  s.homepage     = "https://github.com/kyotaw/bFSwift"
  s.license      = "MIT"
  s.author             = { "kyotaw" => "httg1326@gmail.com" }

  s.platform     = :ios, '10.2'

  s.source       = { :git => "https://github.com/kyotaw/bFSwift.git", :commit => "8a78df9af27ae7f3f8f13f8ab3eb370d000dbdb3", :tag => "0.0.1" }
  s.source_files  = "bFSwift/**/*.{swift}"
  s.requires_arc = true
  s.dependency 'CryptoSwift'
  s.dependency 'Alamofire', '~>4.0'
  s.dependency 'SwiftWebSocket', '2.6.5'
  s.dependency 'SwiftyJSON'

end
