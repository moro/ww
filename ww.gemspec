# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ww}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["moro"]
  s.date = %q{2010-01-14}
  s.description = %q{Double Web, framework to build double Web server.}
  s.email = %q{moronatural@gmail.com}
  s.files = ["Rakefile", "lib/ww", "lib/ww/double", "lib/ww/double/mock.rb", "lib/ww/double/spy", "lib/ww/double/spy/request.rb", "lib/ww/double/spy.rb", "lib/ww/double/stub.rb", "lib/ww/double.rb", "lib/ww/servlet.rb", "lib/ww/spy_eye.html.haml", "lib/ww/spy_eye.rb", "lib/ww/store.rb", "lib/ww.rb"]
  s.homepage = %q{http://github.com/moro/ww/}
  s.rdoc_options = ["--title", "ww documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README.rdoc", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Double Web, framework to build double Web server.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_runtime_dependency(%q<rack>, [">= 1.0.1"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_dependency(%q<rack>, [">= 1.0.1"])
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0.9.4"])
    s.add_dependency(%q<rack>, [">= 1.0.1"])
    s.add_dependency(%q<json>, [">= 0"])
  end
end
