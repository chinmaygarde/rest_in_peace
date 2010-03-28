# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rest_in_peace}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chinmay Garde"]
  s.date = %q{2010-03-23}
  s.default_executable = %q{rip}
  s.description = %q{Minimal web framework with a focus on simplicity. Powered by Sinatra and DataMapper}
  s.email = %q{chinmaygarde@gmail.com}
  s.executables = ["rip"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "bin/rip",
     "lib/rest_in_peace.rb",
     "lib/rest_in_peace/generator.rb",
     "lib/rest_in_peace/migration.rb",
     "lib/rest_in_peace/project_settings.rb",
     "lib/rest_in_peace/rip_controller.rb",
     "lib/rest_in_peace/server_manager.rb",
     "lib/rest_in_peace/templates/controller.rb.erb",
     "lib/rest_in_peace/templates/gems",
     "lib/rest_in_peace/templates/html/edit.html.erb",
     "lib/rest_in_peace/templates/html/index.html.erb",
     "lib/rest_in_peace/templates/html/layout.html.erb",
     "lib/rest_in_peace/templates/html/new.html.erb",
     "lib/rest_in_peace/templates/html/show.html.erb",
     "lib/rest_in_peace/templates/image/favicon.ico",
     "lib/rest_in_peace/templates/model.rb.erb",
     "lib/rest_in_peace/templates/readme.txt.erb",
     "lib/rest_in_peace/templates/script/define",
     "lib/rest_in_peace/templates/script/migrate",
     "lib/rest_in_peace/templates/script/server",
     "lib/rest_in_peace/templates/stylesheet/main.css",
     "rest_in_peace.gemspec",
     "test/helper.rb",
     "test/test_rested_db.rb"
  ]
  s.homepage = %q{http://github.com/chinmaygarde/rest_in_peace}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{ReST in Peace}
  s.test_files = [
    "test/helper.rb",
     "test/test_rested_db.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_development_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_development_dependency(%q<datamapper>, [">= 0.10.2"])
      s.add_development_dependency(%q<builder>, [">= 2.2.2"])
      s.add_development_dependency(%q<taps>, [">= 0.2.26"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_dependency(%q<datamapper>, [">= 0.10.2"])
      s.add_dependency(%q<builder>, [">= 2.2.2"])
      s.add_dependency(%q<taps>, [">= 0.2.26"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<sinatra>, [">= 0.9.4"])
    s.add_dependency(%q<datamapper>, [">= 0.10.2"])
    s.add_dependency(%q<builder>, [">= 2.2.2"])
    s.add_dependency(%q<taps>, [">= 0.2.26"])
  end
end

