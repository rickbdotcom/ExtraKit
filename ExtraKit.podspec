#
# Be sure to run `pod lib lint ExtraKit.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'ExtraKit'
  s.version          = '0.6.0'
  s.summary          = 'A collection of useful Swift extensions and scripts.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/rickbdotcom/ExtraKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Richard Burgess' => 'rickb@rickb.com' }
  s.source           = { :git => 'https://github.com/rickbdotcom/ExtraKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'

  s.source_files = 'ExtraKit/common/*.swift'
  s.ios.source_files = 'ExtraKit/ios/*.swift'
  s.preserve_path = 'scripts/*'
  
end
