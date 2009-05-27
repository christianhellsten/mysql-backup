#require 'ruby-debug'

class MysqlBackup
  class << self

    # TODO refactor, too long
    def run
      user      = options['user']
      password  = options['password']
      host      = options['host']
      encoding  = options['encoding']
      dir       = options['dir']
      format    = options['format']
      keep      = options['keep'] || 10
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

        cmd = "#{path}mysqldump -u#{user} -p#{password} -h#{host} #{mysqldump_options} #{db} --result-file=#{file}"
        
        result = exec_pty(cmd, password)

        # gzip 
        `gzip -fq #{file}`
    
        # Find all backups and sort
        all_backups = Dir.entries(dir).select{|f| f =~ /^#{db}/}.select{|f| File.file? File.join(dir, f) }.sort_by { |f| File.mtime(File.join(dir,f)) }.reverse

        #pp all_backups

        keep_backups = all_backups[0..keep] # eg. 10 latest

        remove = all_backups - keep_backups

        remove.each do |file|
          puts "Removing backup '#{file}' keeping #{keep}"
          FileUtils.rm_rf(file)
        end
      end

    end

  end
end
