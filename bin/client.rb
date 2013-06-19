#!/usr/bin/env ruby

require 'mechanize'

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
client_query['zone'] = ['']
client.query = client_query.map do |key, values|
  values.map do |value|
    "#{CGI.escape key}=#{CGI.escape value}"
  end
end.flatten.join '&'
`x-www-browser "#{(page.uri + client).to_s}"`
