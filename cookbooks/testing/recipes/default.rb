#
# Cookbook:: testing
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

testing_foo 'something' do
  action :create
  some_string 'somethingelse'
  some_bool true
  debug true
end
