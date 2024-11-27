if ENV["RAILS_ENV"] == "test"
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter '/config/'
    add_filter '/spec/'
    add_filter '/test/'
  end
end