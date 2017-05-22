
Pod::Spec.new do |s|
  s.name             = 'MAGMessageService'
  s.version          = '0.1.1'
  s.summary          = 'Service for chat.'
  s.description      = <<-DESC
Service for chat.
                       DESC
  s.homepage         = 'https://github.com/Magora-IOS/MAGMessageService'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author           = { 'Mikhail Zykov' => 'zykov@magora.systems' }
  s.source           = { :git => 'https://github.com/Magora-IOS/MAGMessageService.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'MAGMessageService/Classes/**/*'
  s.dependency 'SocketRocket', '~> 0.5.1'
end
