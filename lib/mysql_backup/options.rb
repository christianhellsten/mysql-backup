module MysqlBackup
  class Options
    class << self
      def options
        @@options ||= begin
          begin
            options = YAML::load(File.read('/etc/mysql_backup'))
          rescue Errno::ENOENT
            print <<-DOC

          You need to create the configuration file.

          To create the file, run the following commands from the command line:

          $ sudo mysql_backup_install

            DOC
            exit
          end
        end
      end
    end
  end
end
