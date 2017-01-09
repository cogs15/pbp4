#!/usr/bin/env ruby

require 'csv'

require './lib/mysql_client.rb'
require './lib/http_client.rb'

mysql_client = MySQLClient.new
http_client = HttpClient.new

nthreads = 1

require 'date'

Date.today

 date_year = Date.today


instagram_handles = mysql_client.get_instagram()

instagram_handles.each_with_index do |instagram_handle|
      puts "#{instagram_handle} ..."
      instagram_url = "https://www.instagram.com/#{instagram_handle}/"

        doc = http_client.get_html(instagram_url)

sleep = 5

#//*[@id="react-root"]/section/main/article/ul/li[2]/a/span


      followers_raw =  doc.at_xpath('/html/body/span/section/main/article/header/div[2]/ul/li[2]/span/span')
    print "#{followers_raw}"

        #    if not(followers_raw.nil?)
    #  if followers_raw.include?('K')
    #    #followers_raw = (followers_raw.sub! 'K', '')
#split = followers_raw.split('K')
#        followers = split[0].to_f * 1000
    #  else
      #  followers = followers_raw.delete(',').to_f
    #  end
    #end
followers = followers_raw

    r = [date_year, instagram_handle, followers]



  mysql_client.write_instagram(r)
end


      STDOUT.flush
