# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rested_db}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chinmay Garde"]
  s.date = %q{2010-03-06}
  s.default_executable = %q{rested}
  s.description = %q{Easily expose database entities as REST resources}
  s.email = %q{chinmaygarde@gmail.com}
  s.executables = ["rested"]
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
     "bin/rested",
     "lib/rested_db.rb",
     "lib/rested_db/generator.rb",
     "lib/rested_db/migration.rb",
     "lib/rested_db/project_settings.rb",
     "lib/rested_db/rested_controller.rb",
     "lib/rested_db/server_manager.rb",
     "lib/rested_db/templates/controller.rb.erb",
     "lib/rested_db/templates/model.rb.erb",
     "lib/rested_db/templates/readme.txt.erb",
     "lib/rested_db/templates/script/define",
     "lib/rested_db/templates/script/migrate",
     "lib/rested_db/templates/script/server",
     "rested_db.gemspec",
     "test/helper.rb",
     "test/test_rested_db.rb"
  ]
  s.homepage = %q{http://github.com/chinmaygarde/rested_db}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{RESTed DB}
  s.test_files = [
    "test/helper.rb",
     "test/test_rested_db.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_development_dependency(%q<datamapper>, [">= 0.10.2"])
      s.add_development_dependency(%q<builder>, [">= 2.2.2"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<datamapper>, [">= 0.10.2"])
      s.add_dependency(%q<builder>, [">= 2.2.2"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<datamapper>, [">= 0.10.2"])
    s.add_dependency(%q<builder>, [">= 2.2.2"])
  end
end

