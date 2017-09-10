Pod::Spec.new do |s|
  s.name         = "HermesNetwork"
  s.version      = "0.1.0"
  s.summary      = "Concrete Implementation of Isolated/Testable Network Layer in Swift"
  s.description  = <<-DESC
    This project aims to show how to write an isolated and testable networking layer in Swift. Original article can be found in README file.'
  DESC
  s.homepage     = "https://github.com/malcommac/HermesNetwork"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Daniele Margutti" => "hello@danielemargutti.com" }
  spec.social_media_url = 'http://twitter.com/danielemargutti'
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
