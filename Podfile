platform :ios, '10.0'
use_frameworks!

def shared
pod 'CMPComapiFoundation', :path => '/Users/dominik.kowalski/Documents/comapi-sdk-ios-objc'
pod 'JWT'
end

target 'CMPComapiFoundation' do
pod 'SocketRocket'
end

target 'SampleApp' do
shared
end

target 'SampleAppSwift' do
shared
pod 'SnapKit'
end

