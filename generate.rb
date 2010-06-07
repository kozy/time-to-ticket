#!/usr/bin/env ruby

if ARGV[0].nil? or not ['model', 'migration'].include?(ARGV[0])
  puts "Usage:"
  puts "#{__FILE__} model ModelName|model_name"
  puts "#{__FILE__} migration SomeChangeToSomeTable|some_change_to_some_table"
  exit
end

require 'rubygems'
require 'active_support/core_ext/string/inflections'
include ActiveSupport::CoreExtensions::String::Inflections

# setup
option = ARGV[0]
name = ARGV[1]
name = name.camelize
Dir.mkdir('migrate') unless File.exists?('migrate')

# get the new_version string
versions = Dir.entries("migrate/").map { |file| file.to_i }
last_version = versions.sort.last
new_version = sprintf("%03d", (last_version + 1))

if option == 'model'
  # create the model file
  puts "Creating: #{name}.rb"
  File.open("#{name}.rb", 'w') do |file|
    file.write "class #{name} < ActiveRecord::Base\nend"
  end

  # create the model proxy file
  puts "Creating: #{name}Proxy.rb"
  File.open("#{name}Proxy.rb", 'w') do |file|
    file.write "class #{name}Proxy < OSX::ActiveRecordProxy\nend"
  end

  # create the migration file
  filename = "migrate/#{new_version}_create_#{name.tableize}.rb"
  puts "Creating: #{filename}"
  File.open(filename, 'w') do |file|
    str  = "class Create#{name.pluralize} < ActiveRecord::Migration\n"
    str += "  def self.up\n"
    str += "    create_table :#{name.tableize} do |t|\n"
    str += "      # t.column :title, :string, :default => 'foo'\n"
    str += "    end\n"
    str += "  end\n"
    str += "\n"
    str += "  def self.down\n"
    str += "    drop_table :#{name.tableize}\n"
    str += "  end\n"
    str += "end"
  
    file.write str
  end
  
elsif option == 'migration'
  # create the migration file
  filename = "migrate/#{new_version}_#{name.underscore}.rb"
  puts "Creating: #{filename}"
  File.open(filename, 'w') do |file|
    str  = "class #{name} < ActiveRecord::Migration\n"
    str += "  def self.up\n"
    str += "    # add_column :table, :column, :type\n"
    str += "  end\n"
    str += "\n"
    str += "  def self.down\n"
    str += "  end\n"
    str += "end"
  
    file.write str
  end
end

