Pod::Spec.new do |s|
  s.name             = "AnchorPal"
  s.version          = "0.9.7"
  s.summary          = "A library inspired by SnapKit."
  s.description      = <<-DESC
                       Create constraints on top of the NSLayoutAnchor API, with custom dimension and system spacing support.
                       DESC
  s.homepage         = "https://github.com/sugarmo/AnchorPal"
  s.license          = 'MIT'
  s.author           = { "Steven Mok" => "su9ar.mo@gmail.com" }
  s.source           = { :git => "https://github.com/sugarmo/AnchorPal.git", :tag => s.version.to_s }
  s.swift_versions    = ['5.0']

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.requires_arc = true

  s.source_files = "Sources/**/*.swift"
end
