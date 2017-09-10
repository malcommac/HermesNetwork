Pod::Spec.new do |s|
  s.name         = "HermesNetwork"
  s.version      = "0.1.0"
  s.summary      = "Concrete Implementation of Isolated/Tesable Network Layer in Swift"
  s.description  = <<-DESC
    How to write a stable and testable networking layer in Swift
  DESC
  s.homepage     = "https://github.com/malcommac/HermesNetwork.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Daniele Margutti" => "hello@danielemargutti.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/malcommac/HermesNetwork.git.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
  s.dependency 'HydraAsync'
end
