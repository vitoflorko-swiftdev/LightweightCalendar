Pod::Spec.new do |s|
  s.name             = 'LightweightCalendar'
  s.version          = '0.3.0'
  s.summary          = 'Slim iOS Calendar control with high performance and easy customization'
 
  s.description      = <<-DESC
This calendar control provides iOS developers with a simple and quick way to display a nice size agnostic calendar without the need to struggle with some complicated framework
                       DESC
 
  s.homepage         = 'https://github.com/vitoflorko-swiftdev/LightweightCalendar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vito Florco' => 'vitoflorko@icloud.com' }
  s.source           = { :git => 'https://github.com/vitoflorko-swiftdev/LightweightCalendar.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '11.0'
  s.source_files = 'LightweightCalendar/LightweightCalendar/LWCalendar.swift'
 
end
