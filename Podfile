platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

$env=ENV['COMAPI_XCODE_ENVIRONMENT']

abstract_target 'Shared' do
  pod 'SocketRocket', '~> 0.6'

  target 'CMPComapiFoundation' do
    target 'ComapiFoundationSample' do
      pod 'JWT'

      target 'CMPComapiFoundationTests' do
        
      end
    end

    target 'ComapiFoundationSample-Swift' do
      pod 'JWT'
      pod 'SnapKit'
    end
  end
end

  # if $env == 'production'
  #   pod 'CMPComapiFoundation'
  # elsif $env == 'development'
  #   pod 'CMPComapiFoundation', :git => 'https://github.com/comapi/comapi-sdk-ios-objc', :branch => 'dev'
  # else
  #   pod 'CMPComapiFoundation', :path => Dir.pwd
  # end


