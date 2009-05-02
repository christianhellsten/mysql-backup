#
# This errors means the directory doesn't exist:
# /usr/local/lib/ruby/1.8/expect.rb:17:in `expect': undefined method `chr' for nil:NilClass (NoMethodError)
#
class MysqlBackup
  class << self
    def exec_pty(cmd)
      #$expect_verbose = true 
      PTY.spawn(cmd) do |reader, writer, pid|
        reader.expect(/Enter password/) do |line|
          writer.puts ''
        end 

        while line=reader.gets
    #      print line
        end
      end 
    end
  end
end
