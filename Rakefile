require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'fileutils'
require 'spec/rake/spectask'
require 'lib/ww'
include FileUtils

NAME              = "ww"
AUTHOR            = "moro"
EMAIL             = "moronatural@gmail.com"
DESCRIPTION       = "Double Web, framework to build double Web server."
HOMEPAGE          = "http://github.com/moro/#{NAME}/"
BIN_FILES         = %w(  )

VERS              = Ww::Version
REV = File.read(".svn/entries")[/committed-rev="(d+)"/, 1] rescue nil
CLEAN.include ['**/.*.sw?', '*.gem', '.config']
RDOC_OPTS = [
	'--title', "#{NAME} documentation",
	"--charset", "utf-8",
	"--opname", "index.html",
	"--line-numbers",
	"--main", "README.rdoc",
	"--inline-source",
]

task :default => [:spec]
task :package => [:clean]

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = %w[--colour --format progress --loadby --reverse]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

spec = Gem::Specification.new do |s|
	s.name              = NAME
	s.version           = VERS
	s.platform          = Gem::Platform::RUBY
	s.has_rdoc          = true
	# s.extra_rdoc_files  = ["README.rdoc", "ChangeLog"]
	s.rdoc_options     += RDOC_OPTS + ['--exclude', '^(examples|extras)/']
	s.summary           = DESCRIPTION
	s.description       = DESCRIPTION
	s.author            = AUTHOR
	s.email             = EMAIL
	s.homepage          = HOMEPAGE
	s.executables       = BIN_FILES
	s.bindir            = "bin"
	s.require_path      = "lib"
	s.test_files        = Dir["test/*_test.rb"]

	s.add_dependency('sinatra', '>=0.9.4')
	s.add_dependency('rack', '>=1.0.1')
	s.add_dependency('haml', '>=2.2.13')
	#s.add_dependency('json', '>=1.2.0')
	#s.required_ruby_version = '>= 1.8.2'

	s.files = %w(README.rdoc ChangeLog MIT-LICENSE Rakefile) +
		Dir.glob("{bin,doc,spec,lib,templates,generator,extras,website,script}/**/*") + 
		Dir.glob("ext/**/*.{h,c,rb}") +
		Dir.glob("example/**/*") +
		Dir.glob("tools/*.rb") +
		Dir.glob("rails/*.rb")

	s.extensions = FileList["ext/**/extconf.rb"].to_a
end

Rake::GemPackageTask.new(spec) do |p|
	p.need_tar = true
	p.gem_spec = spec
end

task :install do
	name = "#{NAME}-#{VERS}.gem"
	sh %{rake package}
	sh %{gem install --no-rdoc --no-ri pkg/#{name}}
end

task :uninstall => [:clean] do
	sh %{gem uninstall #{NAME}}
end

desc 'Show information about the gem.'
task :debug_gem do
	puts spec.to_ruby
end

desc 'Update gem spec'
task :gemspec do
  open("#{NAME}.gemspec", 'w').write spec.to_ruby
end


Rake::RDocTask.new do |rdoc|
	rdoc.rdoc_dir = 'html'
	rdoc.options += RDOC_OPTS
	rdoc.template = "resh"
	#rdoc.template = "#{ENV['template']}.rb" if ENV['template']
	if ENV['DOC_FILES']
		rdoc.rdoc_files.include(ENV['DOC_FILES'].split(/,\s*/))
	else
		rdoc.rdoc_files.include('README.rdoc', 'ChangeLog')
		rdoc.rdoc_files.include('lib/**/*.rb')
		rdoc.rdoc_files.include('ext/**/*.c')
	end
end

