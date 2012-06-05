require 'spec_helper.rb'
describe Article do
  it 'should check if Article name is nil' do
    a = Article.new
    a.name.should == nil
  end
end

