Pod::Spec.new do |s|
  s.name     = 'libFTDI'
  s.version  = '0.2.0'
  s.license      = { :type => 'Commerical', :file => 'LICENSE', :text => 'Permission is not used without any request' }

  s.summary  = 'libFTDI library is a FTDI dynamic libary.'
  s.homepage = 'http://www.ftdi.com'
  s.author   = { 'Richard' => 'othercat@gmail.com' }

  s.source   = { :git => 'https://github.com/othercat/ThirdPartTools.git' }

  s.description = 'Something need to fill it furture for libFTDI. With libusb 1.0.9 and libusb compat 0.1.4'

  s.platform = :osx

  s.source_files = 'CocoaClasses/libFTDI/*.{c,m,h}'

  s.libraries = 'ftdi.1','usb-1.0.0','usb-0.1.4'

  #s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '/usr/local/lib' }

  s.requires_arc = false

end
