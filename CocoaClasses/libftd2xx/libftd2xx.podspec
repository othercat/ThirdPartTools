Pod::Spec.new do |s|
  s.name     = 'libftd2xx'
  s.version  = '1.1.0'
  s.license      = { :type => 'Commerical', :file => 'LICENSE', :text => 'Permission is not used without any request' }

  s.summary  = 'libftd2xx library is a FTDI communication dynamic libary.'
  s.homepage = 'http://www.ftdi.com'
  s.author   = { 'Richard' => 'othercat@gmail.com' }

  s.source   = { :git => 'https://github.com/othercat/ThirdPartTools.git' }

  s.description = 'Something need to fill it furture for libftd2xx.'

  s.platform = :osx

  s.source_files = 'CocoaClasses/libftd2xx/*.{c,m,h}'

  s.library = 'ftd2xx.1.1.0'

  #s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '/usr/local/lib' }

  s.requires_arc = false

end
