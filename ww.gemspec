# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ww}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["moro"]
  s.date = %q{2010-08-06}
  s.description = %q{Double Web, framework to build double Web server.}
  s.email = %q{moronatural@gmail.com}
  s.files = ["README.rdoc", "ChangeLog", "MIT-LICENSE", "Rakefile", "spec/spec_helper.rb", "spec/usage", "spec/usage/spy_spec.rb", "spec/usage/stub_spec.rb", "spec/ww", "spec/ww/application_spec.rb", "spec/ww/double", "spec/ww/double/mock", "spec/ww/double/mock/expectation_spec.rb", "spec/ww/double/mock_spec.rb", "spec/ww/double/spy_spec.rb", "spec/ww/double/stub_spec.rb", "spec/ww/double_spy_request_spec.rb", "spec/ww/server_integration_spec.rb", "spec/ww/server_spec.rb", "spec/ww/servlet_spec.rb", "lib/ww", "lib/ww/application.rb", "lib/ww/double", "lib/ww/double/mock", "lib/ww/double/mock/expectation.rb", "lib/ww/double/mock.rb", "lib/ww/double/spy", "lib/ww/double/spy/request.rb", "lib/ww/double/spy.rb", "lib/ww/double/stub.rb", "lib/ww/double.rb", "lib/ww/dsl", "lib/ww/dsl/definition_base.rb", "lib/ww/dsl/mock_definition.rb", "lib/ww/dsl/spy_definition.rb", "lib/ww/dsl/stub_definition.rb", "lib/ww/server.rb", "lib/ww/servlet.rb", "lib/ww/spy_eye.html.haml", "lib/ww/spy_eye.rb", "lib/ww/store.rb", "lib/ww.rb", "example/spy_eye.ru", "example/spy_eye_output.html"]
  s.homepage = %q{http://github.com/moro/ww/}
  s.rdoc_options = ["--title", "ww documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README.rdoc", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Double Web, framework to build double Web server.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_runtime_dependency(%q<rack>, [">= 1.0.1"])
      s.add_runtime_dependency(%q<haml>, [">= 2.2.13"])
    else
      s.add_dependency(%q<sinatra>, [">= 0.9.4"])
      s.add_dependency(%q<rack>, [">= 1.0.1"])
      s.add_dependency(%q<haml>, [">= 2.2.13"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0.9.4"])
    s.add_dependency(%q<rack>, [">= 1.0.1"])
    s.add_dependency(%q<haml>, [">= 2.2.13"])
  end
end
