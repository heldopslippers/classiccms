require 'spec_helper'
require 'stringio'

describe Classiccms do
  before :all do
    #set directory
    #$default[:dir] = Dir.pwd
  end
  before :each do
    clear_tmp
  end
  it 'should have root_dir method' do
    #ClassicCMS.root_dir.should == Dir.pwd
  end
  it 'should have app_dir method' do
    #ClassicCMS.app_dir.should include 'lib/classicCMS'
  end

  after :all do
    #Dir::chdir $default[:dir]
  end
end
