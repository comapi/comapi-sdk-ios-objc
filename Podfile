platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

$env=ENV['COMAPI_XCODE_ENVIRONMENT']

target 'CMPComapiFoundation' do
  pod 'SocketRocket'
end

abstract_target 'Shared' do
  pod 'JWT'
  if $env == 'production'
    pod 'CMPComapiFoundation'
  elsif $env == 'development'
    pod 'CMPComapiFoundation', :git => 'https://github.com/comapi/comapi-sdk-ios-objc', :branch => 'dev'
  else
    pod 'CMPComapiFoundation', :path => Dir.pwd
  end

  target 'ComapiFoundationSample' do
    target 'CMPComapiFoundationTests' do
      inherit! :search_paths
    end
  end
  
  target 'ComapiFoundationSample-Swift' do
    pod 'SnapKit'
  end
end


