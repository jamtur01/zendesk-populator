$:.push File.expand_path("../lib", __FILE__)

require 'version'

Gem::Specification.new do |s|
  s.name = "zendesk-populator"
  s.version = ZendeskPopulator::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Turnbull"]
  s.description = "A web-based front-end and tool to generate Zendesk orgs and users from CSV."
  s.email = "james@lovedthanlost.net"
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = `git ls-files`.split("\n")
  s.homepage = "http://github.com/jamtur01/zendesk-populator/"
  s.licenses = ["APL2"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "A command line tool to generate Zendesk orgs and users from CSV."
  s.add_dependency(%q<httparty>, [">= 0"])
  s.add_dependency(%q<sinatra>, [">= 0"])
  s.add_dependency(%q<sinatra-static-assets>, [">= 0"])
  s.add_dependency(%q<haml>, [">= 0"])
  s.add_dependency(%q<sass>, [">= 0"])
  s.add_dependency(%q<sqlite3>, [">= 0"])
  s.add_dependency(%q<fastercsv>, [">= 0"])
  s.add_dependency(%q<activerecord>, ["3.0.3"])
end

