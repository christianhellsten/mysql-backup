#
# This errors means the directory doesn't exist or there's a problem with permissions:
# /usr/local/lib/ruby/1.8/expect.rb:17:in `expect': undefined method `chr' for nil:NilClass (NoMethodError)
#
module MysqlBackup
  class Pty
    class << self
      def exec_pty(cmd, password)
#        $expect_verbose = true # NOTE uncomment to print output 
        password = '' if password.nil?

        PTY.spawn(cmd) do |reader, writer, pid|
          begin
            reader.expect(/Enter password/, 1) do |line|
              writer.puts password
            end 
          rescue
            puts "WARN: #{$!}" # TODO this can fail with unknown consequences
            puts reader.gets
          end

          begin
            while line = reader.gets
              # TODO detect errors we should act upon
  #            raise line if line.strip.length > 1
            end
          rescue Errno::EIO # EOF
          end
        end 
      end
    end
  end
end
