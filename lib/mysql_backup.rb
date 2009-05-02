$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
#
# This errors means the directory doesn't exist:
# /usr/local/lib/ruby/1.8/expect.rb:17:in `expect': undefined method `chr' for nil:NilClass (NoMethodError)
#
require 'rubygems'
require 'sequel'
require 'expect'
require 'pty'
require 'pp'

module MysqlBackup

  VERSION = '1.0.0'

  class << self
    def run
      options = nil

      begin
        options = YAML::load(File.read('/etc/mysql_backup'))
      rescue Errno::ENOENT
        print <<-DOC

      You need to create the configuration file.

      To create the file, run the following commands from the command line:

sudo -s
echo "
user: xxx
password: xxx
host: localhost
dir: /tmp
format: %d-%m-%y
" > /etc/mysql_backup
exit

        DOC
        exit
      end

      #$expect_verbose = true 

      def exec_pty(cmd)
        PTY.spawn(cmd) do |reader, writer, pid|
          reader.expect(/Enter password/) do |line|
            writer.puts ''
          end 

          while line=reader.gets
      #      print line
          end
        end 
      end

      user      = options['user']
      password  = options['password']
      host      = options['host']
      encoding  = options['encoding']
      dir       = options['dir']
      format    = options['format']

      #pp options

      timestamp = Time.now.strftime(format)

      connection = Sequel.mysql nil, :user => user, :password => password, :host => host, :encoding => encoding

      databases = []
      connection['show databases;'].each do |db|
        databases << db[:Database]
      end
      databases = databases - ['mysql', 'test', 'information_schema']

      databases.each do |db|
        raise "The backup directory '#{dir}' doesn't exist" if !File.exist?(dir)

        file = File.join(dir, "#{db}_#{timestamp}.sql")
        p "Backing up #{db.ljust(40)} > #{file}"
        cmd = "mysqldump -u#{user} -p#{password} -h#{host} -Q -c -C --add-drop-table --add-locks --quick --lock-tables #{db} > #{file}"
        
        result = exec_pty(cmd)
      end
    end
  end
end
