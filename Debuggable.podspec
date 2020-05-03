Pod::Spec.new do |s|
		s.name 				= "Debuggable"
		s.version 			= "5.1.0"
		s.summary         	= "Sort description of 'Debuggable' framework"
	    s.homepage        	= "https://github.com/amine2233/Debuggable"
	    s.license           = "MIT"
	    s.author            = { 'Amine Bensalah' => 'amine.bensalah@outlook.com' }
	    s.ios.deployment_target = '12.0'
	    s.osx.deployment_target = '10.13'
	    s.tvos.deployment_target = '12.0'
	    s.watchos.deployment_target = '5.0'
	    s.requires_arc = true
	    s.source            = { :git => "https://github.com/amine2233/Debuggable.git", :tag => s.version.to_s }
	    s.source_files      = "Sources/**/*.swift"
  		s.module_name = s.name
  		s.swift_version = '5.0'
  		s.pod_target_xcconfig = {
    		'SWIFT_VERSION' => s.swift_version
		}
		s.test_spec 'Tests' do |test_spec|
			test_spec.source_files = 'Tests/**/*.{swift}'
		end
	end
