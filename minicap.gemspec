Gem::Specification.new do |s|
  s.name = %q{minicap}
  s.version = "1.0.6"
  s.date = %q{2010-11-10}
  s.authors = ["Mat Trudel"]
  s.email = %q{mat@well.ca}
  s.summary = %q{Minicap provides a minimal yet functional set of git specific cap recipes}
  s.description = %q{Minicap provides a minimal yet functional set of git specific cap recipes. 
    Minicap's recipes roughly mimic those in the standard capistrano distribution, but are 
    much smaller and faster to understand'}
  s.files = [ "README.md", "LICENCE", "lib/minicap.rb"]
  s.add_dependency("capistrano")
end
