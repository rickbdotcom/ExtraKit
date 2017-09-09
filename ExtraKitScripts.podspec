#
# Be sure to run `pod lib lint ExtraKit.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'ExtraKitScripts'
  s.version          = '0.2.1'
  s.summary          = 'A collection of useful Swift extensions.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/rickbdotcom/ExtraKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Richard Burgess' => 'rickb@rickb.com' }
  s.source           = { :http => "#{s.homepage}/releases/download/#{s.version}/scripts.zip" }
end
