$:.unshift File.dirname(__FILE__)

#
# TODO Cleanup code
#
require 'sequel'
require 'pty'
require 'expect'

['install', 'pty', 'options', 'backup'].each do |file|
  require File.dirname(__FILE__) + "/mysql_backup/#{file}"
end

module MysqlBackup
  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end
  
  def self.run
    Backup.run
  end

  def self.options
    Options.options
  end

  def self.install
    Install.install
  end
end

if __FILE__ == $0
  MysqlBackup.run
end
