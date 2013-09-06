platform :ios, '6.0'
# inhibit_all_warnings!

pod 'MBProgressHUD', '~> 0.6'
pod 'AFNetworking', '~> 1.0'
pod 'Mixpanel', '~> 2.0.0'
pod 'NewRelicAgent', '~> 1.309.0'
# pod 'Stripe', :git => 'https://github.com/stripe/stripe-ios.git'
pod 'PaymentKit', :git => 'https://github.com/stripe/PaymentKit.git'
pod 'SSKeychain', '~> 1.0.2'
pod 'ReactiveCocoa', '~> 1.5.0'
pod 'FormatterKit', '~> 1.1.2'
pod 'TTTAttributedLabel'
pod 'DTCoreText', '~> 1.6.4'
pod 'FXBlurView', '~> 1.3.2'

# pod 'SocketRocket', :podspec => 'SocketRocket.podspec'
# pod 'PonyDebugger', :podspec => 'PonyDebugger.podspec'

target :KiwiUnitTest, exclusive: true do
  pod 'Kiwi', '~> 2.0.6'
end

post_install do |installer|
    prefix_header = installer.config.project_pods_root + 'Pods-prefix.pch'
    text = prefix_header.read + "#define _AFNETWORKING_PIN_SSL_CERTIFICATES_\n"
    prefix_header.open('w') { |file| file.write(text) }
end

# post_install do |installer|
#   installer.project.targets.each do |target|
#     target.build_configurations.each do |config|
#       config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
#       # puts "#{target.name}"
#     end
#   end
# end
