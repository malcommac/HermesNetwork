Pod::Spec.new do |s|
  s.name         = "HermesNetwork"
  s.version      = "0.1.0"
  s.summary      = "Concrete Implementation of Isolated/Tesable Network Layer in Swift"
  s.description  = <<-DESC
    This project aims to show how to write an isolated and testable networking layer in Swift. Original article can be found on danielemargutti.com as '
How to write Networking Layer in Swift (Updated)'
  DESC
  s.homepage     = "https://github.com/malcommac/HermesNetwork"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Daniele Margutti" => "hello@danielemargutti.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/malcommac/HermesNetwork.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'
  s.dependency 'HydraAsync'
end
