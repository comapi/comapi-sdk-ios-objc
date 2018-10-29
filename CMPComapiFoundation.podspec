Pod::Spec.new do |s|
  s.name             =	'comapi-sdk-ios-objc'
  s.version          =	'0.9.0'
  s.license          = 	'MIT'
  s.summary          =	'Foundation library for connecting to and consuming COMAPI services'
  s.description      = <<-DESC
# iOS SDK for Comapi
Client to connect your iOS application with [Comapi](http://comapi.com/) services and add it as a channel to our cloud messaging platform. Written in Objective-C.
For more information about the integration please visit [the website](http://docs.comapi.com/reference#one-sdk-ios).
						DESC
  s.homepage         = 'https://github.com/comapi/comapi-sdk-ios-objc'
  s.author           = { 'Comapi' => 'support@comapi.com' }
  s.source           =  { :git => 'https://github.com/comapi/comapi-sdk-ios-objc', :tag => '0.9.0' }
  s.social_media_url = 'https://twitter.com/comapimessaging'

  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'Sources/**/*.{h,m}', 'CMPComapiFoundation/*.h'
  s.resources = []
end
