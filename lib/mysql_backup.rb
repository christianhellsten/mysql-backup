#
# TODO Cleanup code
#
require 'sequel'
require 'pty'

require 'lib/mysql_backup/backup'
require 'lib/mysql_backup/options'
require 'lib/mysql_backup/pty'
require 'lib/mysql_backup/install'

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

