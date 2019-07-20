#
# Be sure to run `pod lib lint ExtraKit.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'ExtraKit'
  s.version          = '0.8.0'
  s.summary          = 'A collection of useful Swift extensions and scripts.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/rickbdotcom/ExtraKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Richard Burgess' => 'rickb@rickb.com' }
  s.source           = { :git => 'https://github.com/rickbdotcom/ExtraKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.swift_version    = '5.1'  
  
  s.source_files = 'Sources/ExtraKit/common/*.swift'
  s.ios.source_files = 'Sources/ExtraKit/ios/*.swift'
  
end
