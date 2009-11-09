# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stumb}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["moro"]
  s.date = %q{2009-11-09}
  s.description = %q{store and show stubbed web-request.}
  s.email = %q{moronatural@gmail.com}
  s.files = ["Rakefile", "lib/stumb", "lib/stumb/servlet.rb", "lib/stumb/sheet.html.haml", "lib/stumb/stamp.rb", "lib/stumb/stamp_sheet.rb", "lib/stumb/stub.rb", "lib/stumb.rb"]
  s.homepage = %q{http://github.com/moro/stumb/}
  s.rdoc_options = ["--title", "stumb documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README.rdoc", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{store and show stubbed web-request.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0.9.4"])
    else
      s.add_dependency(%q<sinatra>, [">= 0.9.4"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0.9.4"])
  end
end
