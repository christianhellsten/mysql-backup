# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mysql-backup}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christian Hellsten"]
  s.date = %q{2009-05-02}
  s.description = %q{mysql-backup is a command line tool that backups all MySQL database instances it can find on a server.}
  s.email = ["christian@aktagon.com"]
  s.executables = ["mysql_backup", "mysql_backup_install"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/mysql_backup", "bin/mysql_backup_install", "lib/mysql_backup.rb", "lib/mysql_backup/install.rb", "lib/mysql_backup/pty.rb", "lib/mysql_backup/backup.rb", "lib/mysql_backup/mysql_backup.yml.example", "test/test_mysql_backup.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://aktagon.com/projects/ruby/mysql-backup}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{mysqlbackup}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{mysql-backup is a command line tool that backups all MySQL database instances it can find on a server.}
  s.test_files = ["test/test_mysql_backup.rb"]

  s.add_dependency(%q<sequel>, [">= 2.0.0"])
  s.add_dependency(%q<highline>, [">= 1.4.0"])

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.8.2"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.2"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.2"])
  end
end
