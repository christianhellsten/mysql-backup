$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'sequel'
require 'expect'
require 'pty'
require 'pp'

class MysqlBackup
  VERSION = '1.1.0'
end

['install', 'pty', 'options', 'backup'].each do |file|
  require "lib/mysql_backup/#{file}"
end

if __FILE__ == $0
  MysqlBackup.run
end
