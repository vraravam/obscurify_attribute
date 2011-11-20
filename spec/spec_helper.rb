ENV["RAILS_ENV"] = "test"

require 'rubygems'
require 'bundler/setup'
require 'active_model'
require 'active_model/validations'
require 'obscurify_attribute'

RSpec.configure do |config|
  config.mock_with :mocha

  config.before(:each) do
    class ObscurifyAttributeItem
      include ::ActiveModel::Validations
      include ::ObscurifyAttribute::Validations

      attr_accessor :first_name, :last_name

      validates_presence_of :first_name
      validates_presence_of :last_name
    end
  end

  config.after(:each) do
    Object.send(:remove_const, :ObscurifyAttributeItem)
  end
end

def putsh(stuff)
  puts "#{ERB::Util.h(stuff)}<br/>"
end

def ph(stuff)
  putsh stuff.inspect
end
