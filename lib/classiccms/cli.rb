require 'fileutils'

module Classiccms
  class Cli
    def self.command(arguments)
      case arguments[0]
      when 'new'    then self.new arguments[1]
      when 'server' then self.server
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

        puts "#{app_name} created!"
      end
    end
    def self.server
      #first check if this is actualy an app
      if File.directory? 'config'  and  File.directory? 'models'
        puts 'Going to start server...'

        #Initialize app with application file
        require 'classiccms/application'
        Classiccms.boot
      else
        puts 'not an app! Try running:'
        puts 'classicCMS new [app name]'
      end
    end
  end
end
