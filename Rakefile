require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rest_in_peace"
    gem.summary = %Q{ReST in Peace}
    gem.description = %Q{Minimal web framework with a focus on simplicity. Powered by Sinatra and DataMapper}
    gem.email = "chinmaygarde@gmail.com"
    gem.homepage = "http://github.com/chinmaygarde/rest_in_peace"
    gem.authors = ["Chinmay Garde"]
    gem.add_dependency "sinatra"
    gem.add_dependency "datamapper"
    gem.add_dependency "builder"
    gem.add_dependency "taps"
    gem.add_dependency "bundler"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end