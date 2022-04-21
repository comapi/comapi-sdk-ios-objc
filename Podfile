platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

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


