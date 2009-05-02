#require 'ruby-debug'

class MysqlBackup
  class << self

    def run
      user      = options['user']
      password  = options['password']
      host      = options['host']
      encoding  = options['encoding']
      dir       = options['dir']
      format    = options['format']
      skip      = options['skip']
      mysqldump_options = options['mysqldump']['options']
      path      = options['mysqldump']['path']


      timestamp = Time.now.strftime(format)

      connection = Sequel.mysql nil, :user => user, :password => password, :host => host, :encoding => encoding

      databases = []
      connection['show databases'].each do |db|
        databases << db[:Database]
      end
      databases = databases - skip #['mysql', 'test', 'information_schema']

      databases.each do |db|
        raise "The backup directory '#{dir}' doesn't exist" if !File.exist?(dir)

        file = File.join(dir, "#{db}_#{timestamp}.sql")
        p "Backing up #{db.ljust(40)} > #{file}"
        cmd = "#{path}mysqldump -u#{user} -p#{password} -h#{host} #{mysqldump_options} #{db} > #{file}"
        
        result = exec_pty(cmd, password)
      end
    end
  end
end
