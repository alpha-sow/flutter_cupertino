Pod::Spec.new do |s|
  s.name             = 'flutter_cupertino'
  s.version          = '0.1.0'
  s.summary          = 'A Flutter plugin for native Cupertino components.'
  s.description      = <<-DESC
A Flutter plugin that provides native iOS and macOS Cupertino components using platform views.
                       DESC
  s.homepage         = 'https://github.com/yourusername/flutter_cupertino'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '16.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
