Pod::Spec.new do |s|
  s.name = 'FindKit'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'FindKit is a framework and sample app that implements Full-Text Search of source code with Swift using Realm'
  s.homepage = 'https://github.com/watanabetoshinori/FindKit'
  s.author = "Watanabe Toshinori"
  s.source = { :git => 'https://github.com/watanabetoshinori/FindKit.git', :tag => s.version }

  s.ios.deployment_target = '11.0'

  s.source_files = 'Sources/**/*.{h,swift}'
  s.resources = 'Sources/**/*.{xib,storyboard}', 'Sources/**/*.xcassets'

  s.dependency 'RealmSwift'
end
