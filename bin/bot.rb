#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require

options = {}
options[:host] = ARGV.shift || 'beta.ogreisland.com'
options[:port] = ARGV.shift || 5300

character_name = ENV['OGRE_CHARACTER']
email = ENV['OGRE_EMAIL']
password = ENV['OGRE_PASSWORD']

agent = Mechanize.new
page = agent.get 'http://beta.ogreisland.com'
form = page.form_with(:name => 'aspnetForm')
form.field_with(:name => 'page$loginemail').value = email
form.field_with(:name => 'page$loginpassword').value = password
page = form.submit form.button_with(:name => 'page$btnLogin')

page = page.link_with(:text => 'Game').click
character_links = Hash[page.search('.charline').map { |c| c.search('.characterbutton a').first }.map { |a| a['href'] =~ /javascript:__doPostBack\('([^']*)','([^']*)'\)/; [a.text, { :target => $1, :argument => $2 }] }]
form = page.form_with(:name => 'aspnetForm')
form.add_field! '__EVENTTARGET', character_links[character_name][:target]
form.add_field! '__EVENTARGUMENT', character_links[character_name][:argument]
page = form.submit
page.search('#page_content_pname').first.text
page.search('#page_content_playbutton').first['onclick'] =~ /window.open\('([^']*)'[^)]*\);/
page = agent.get $1
client = URI.parse page.search('embed[name=preloader]').first['src'].gsub(' ', '%20')
client_query = CGI.parse client.query
options[:auth] = { :id => client_query['char'], :token => client_query['auth'] }

# =========

$: << File.join(File.expand_path(File.dirname(__FILE__)), '..', 'lib')
require 'oirb'

#<OgreIsland::Commands::Base:0x00000001cf37c0 @attributes=["dead", "true"], @key="MEATTRIB">
#Magelius 6c shearing tool, 50 plat, 20k, 11 imp knicks
#Wants knitting tool

module Keyboard
  include EventMachine::Protocols::LineText2
  include OgreIsland::Commands

  def initialize client
    @client = client
    print '>> '
  end

  def mine
    times = 0
    @mine = EventMachine.add_periodic_timer(4.5) do
      if ((times += 1) % 10).zero?
        t = 0.0
        @client.instance_variable_get(:@bags)[:bag].select { |id, item| item[:name] =~ /(\A(\d+) (Iron|Gold) [Bb]ars\Z| Gem\Z)/ }.each do |id, item|
          EventMachine.add_timer(t += 0.1) { @client.send_command ClickBagItem.new :name => 'bag', :id => id }
          EventMachine.add_timer(t += 0.1) { @client.send_command ClickBag.new :name => 'bank', :x => '10.0', :y => '10.0' }
        end
      else
        rock_id = @client.instance_variable_get(:@objects).select { |id, object| object[:clip] == 'rockmine' }.keys.sample
        @client.send_command ClickObject.new :id => rock_id
      end
    end
  end

  def smith
    @smither = EventMachine::PeriodicTimer.new(16) do
      i = 0.0
      iron_count = @client.instance_variable_get(:@bags)[:bag].inject(0) { |result, item| (item.last[:name] =~ /\A(\d+) Iron bars\Z/) ? result + $1.to_i : result }
      if iron_count < 20
        @client.instance_variable_get(:@bags)[:bag].select { |id, item| item[:name] == 'iron Breastplate' }.each do |id, item|
          EventMachine::Timer.new(i += 0.1) { @client.send_command ClickBagItem.new :name => 'bag', :id => id }
          EventMachine::Timer.new(i += 0.1) { @client.send_command ClickBag.new :name => 'bank', :x => '268.9', :y => '27.45' }
        end
        @client.instance_variable_get(:@bags)[:bank].select { |id, item| item[:name] =~ /\A(\d+) Iron bars\Z/ }.to_a.sample(10).each do |item|
          EventMachine::Timer.new(i += 0.1) { @client.send_command ClickBagItem.new :name => 'bank', :id => item.first }
          EventMachine::Timer.new(i += 0.1) { @client.send_command ClickBag.new :name => 'bag', :x => '10.0', :y => '10.0' }
        end
      else
        EventMachine::Timer.new(i += 0.1) { @client.send_command ClickObject.new :id => 'obj11642' }
        EventMachine::Timer.new(i += 0.1) { @client.send_command ClickInventory.new :name => 'res1' }
        EventMachine::Timer.new(i += 0.1) { @client.send_command ClickInventory.new :name => 'item3' }
        EventMachine::Timer.new(i += 0.1) { @client.send_command DoAction.new :action => 'construction' }
      end
    end
  end

  def x
    @client.send_command Logout.new
  end

  def say text
    @client.send_command Say.new :text => text
  end

  def receive_line line
    p begin
      eval line
    rescue Exception => e
      e
    end
    print '>> '
  end
end

EventMachine.set_max_timers 10000

EventMachine::run do
  EventMachine.connect options[:host], options[:port], OgreIsland::Client, options do |client|
    EventMachine.open_keyboard Keyboard, client
  end
end
