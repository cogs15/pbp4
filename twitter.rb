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


twitter_handles = mysql_client.get_twitter()

twitter_handles.each_with_index do |twitter_handle|
      puts "#{twitter_handle} ..."
      twitter_url = "https://twitter.com/#{twitter_handle}"

      doc = http_client.get_html(twitter_url)

      followers_raw =  doc.at_xpath('//*[@id="page-container"]/div[1]/div/div[2]/div/div/div[2]/div/div/ul/li[3]/a/span[2]').text.strip rescue nil

      if not(followers_raw.nil?)
      if followers_raw.include?('K')
        #followers_raw = (followers_raw.sub! 'K', '')
      split = followers_raw.split('K')
      followers = split[0].to_f * 1000
      else
      followers = followers_raw.delete(',').to_f
      end
    end

    r = [date_year, twitter_handle, followers]



    mysql_client.write_twitter(r)
end


      STDOUT.flush
