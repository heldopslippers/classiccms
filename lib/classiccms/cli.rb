require 'fileutils'
require 'classiccms/version'

module Classiccms
  class Cli
    def self.command(arguments)
      case arguments[0]
      when 'new'    then self.new arguments[1]
      when 'server' then self.server
      when 's'      then self.server
      when '-v' then puts "version #{VERSION}"
      else
        puts "you are so smart! I don't know what you mean! (try using new or server)"
      end
    end

    def self.new(app_name)
      if app_name == nil
        puts 'hmm you are using the command wrong: classicCMS new [app name]'
      elsif File::directory? app_name
        puts 'hmm I think that app already exists!'
      else
        #copy scaffold
        FileUtils.cp_r File.join(File.dirname(__FILE__), "scaffold"),  Dir.pwd + "/#{app_name}"

        #replace database
        mongoid = File.read(File.join(Dir.pwd, app_name, 'config/mongoid.yml')).gsub('$', app_name)
        File.open(File.join(Dir.pwd, app_name, 'config/mongoid.yml'), 'w') do |f|
          f.puts mongoid
        end

        #replace database name
        redis = File.read(File.join(Dir.pwd, app_name, 'config/redis.yml')).gsub('$', app_name)
        File.open(File.join(Dir.pwd, app_name, 'config/redis.yml'), 'w') do |f|
          f.puts redis
        end

        puts "#{app_name} created!"
      end
    end
    def self.server
      #first check if this is actualy an app
      system('rackup')
    end
  end
end
