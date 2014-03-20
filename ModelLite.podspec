Pod::Spec.new do |s|
  s.name = 'ModelLite'
  s.version = '0.1.0'
  s.summary = 'An alternative to Core Data for people who like having direct SQL access.'
  s.homepage = 'https://github.com/juliengrimault/ModelLite'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Julien Grimault' => 'grimault.julien@gmail.com' }
  s.source = { :git => 'https://github.com/juliengrimault/ModelLite.git', :branch => 'master' }
  s.source_files  = 'ModelLite/**/*.{h,m}'
  s.library = 'sqlite3'
  s.requires_arc = true
  s.dependency 'FMDB', '~> 2.1'
  s.dependency 'ObjectiveSugar', '~> 1.1'
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'
end
