#helper method for output tests
def capture_log
  origin = $stdout
  $stdout = StringIO.new
  yield
  $stdout = origin
end
alias :discard :capture_log

#helper method for automatic login
def login
  u = create :user
  post '/login', {:username => u.username, :password => u.password}
  follow_redirect!
end

#helper method for clearing temp directory
def clear_tmp
  Dir.chdir $default[:dir]
  FileUtils.rm_rf 'tmp' if File.directory?  'tmp'
  Dir.mkdir 'tmp'
  Dir.chdir 'tmp'
end

#abstraction method for seting up unique index files (tilt is caching!)
def file(extention, content, &block)
  t= Time.now.to_f
  with_constants :CONFIG => {:home => "application/index#{t}"} do
    set_file "views/application/index#{t}.#{extention}", content
    yield
  end
end

#helper method to set files
def set_file(file, content)
  File.open(File.join(Dir.pwd, 'app', file), 'w+') do |f|
    f.puts content
  end
end

#helper method to create directories in app
def create_dir(dir)
  Dir::mkdir 'app/' + dir if !File.directory? 'app/' + dir
end


#require all models
def require_models
  Dir[File.join(Dir.pwd, 'app/models/*.rb')].each {|file| require file }
end

#setup application and start server into in
def setup_app(app_name)
  discard { Classiccms::Cli.command ['new', app_name] }
  Dir.chdir app_name

  yield
end

#stub constants
def with_constants(constants, &block)
  saved_constants = {}
  constants.each do |constant, val|
    saved_constants[ constant ] = Object.const_get( constant )
    Kernel::silence_warnings { Object.const_set( constant, val ) }
  end
 
  begin
    block.call
  ensure
    constants.each do |constant, val|
      Kernel::silence_warnings { Object.const_set( constant, saved_constants[ constant ] ) }
    end
  end
end
