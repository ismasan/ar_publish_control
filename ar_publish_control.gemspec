# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ar_publish_control}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ismael Celis"]
  s.date = %q{2008-11-18}
  s.description = %q{Publish control for ActiveRecord}
  s.email = ["ismaelct@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "ar_publish_control.gemspec", "lib/ar_publish_control.rb", "script/console", "script/destroy", "script/generate", "spec/ar_publish_control_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/db.rake", "tasks/rspec.rake"]
  s.has_rdoc = false
  s.homepage = %q{http://www.estadobeta.com}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ar_publish_control}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Publish control for ActiveRecord, with start and optional end dates}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.1.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.1.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.1.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
