Pod::Spec.new do |s|
  s.name         = "ELAlertView"
  s.version      = "1.0.0"
  s.summary      = "Custom AlertView"
  s.description  = <<-DESC
          Highly configurable iOS Alert Views with custom content views
                   DESC
  s.homepage     = "https://github.com/rainer-liao/ELAlertView"
  s.license      = "MIT"
  s.author             = { "rainer-liao" => "rainer.liao@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/rainer-liao/ELAlertView.git", :tag => s.version.to_s}
  s.source_files  = "ELAlertView", "ELAlertView/ELAlertView/ELAlertView/*.{h,m}"
end
