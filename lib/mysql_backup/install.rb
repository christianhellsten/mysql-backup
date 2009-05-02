require 'fileutils'

class MysqlBackup
  CONF_FILE = '/etc/mysql_backup'

  class << self
    def ask_for_options
      require "highline/import"

      puts <<-PROMPT

      Please enter your MySQL username and password.

      PROMPT

      user     = ask("MySQL username   : ")
      password = ask("MySQL password   : ") { |q| q.echo = false }
      host     = ask("MySQL host       : ") { |q| q.default = 'localhost' }
      dir      = ask("Backup directory : ") { |q| q.default = '/tmp' }

      [user, password, host, dir]
    end

    def install
      begin
        if File.exist?(CONF_FILE)
          puts <<-WARN

          #{CONF_FILE} already exists. Remove it and try again.
          
          WARN

          exit
        end

        user, password, host, dir = ask_for_options

        File.open(CONF_FILE, 'w') do |file|
          template = File.read(File.join(File.dirname(__FILE__), 'mysql_backup.yml.example'))
          template.gsub!('USER', user)
          template.gsub!('PASS', password)
          template.gsub!('HOST', host)
          template.gsub!('DIR', dir)
          
          file << template
        end

        FileUtils.chmod(750, CONF_FILE)

        puts <<-ERR


          Configuration file #{CONF_FILE} written.

          You can now backup all databases by running the following command:

            $ mysql_backup

        ERR

      rescue Errno::EACCES => e
        puts <<-ERR

          You need to run this command with sudo or as root.

        ERR
        exit
      end
    end
  end
end
