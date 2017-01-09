#!/usr/bin/env ruby

require 'csv'

require './lib/mysql_client.rb'
require './lib/http_client.rb'

mysql_client = MySQLClient.new
http_client = HttpClient.new

#year = ARGV[0]
#division = 1

# Base URL for relative team links

base_url = 'http://laxpower.com/recruits/recruits.php?action=viewRcd&db=recruits2014'

roster_xpath = '//*[@id="grid"]/table[2]/tbody/tr[position() > 2]'

for i in (1..5).step(1) do

      team_roster_url = "http://laxpower.com/recruits/recruits.php?action=viewRcd&db=recruits2017&q=&page=#{i}"
      doc = http_client.get_html(team_roster_url)

      doc.xpath(roster_xpath).each do |row|

r = []
        row.xpath("td").each_with_index do |d|
          r += [d.text.strip]
            end


                lp << r

              mysql_client.write_laxpower(lp)

            end
          end

    #  recruit_id = row.at_xpath('td[1]').text.strip.to_nil rescue nil
    #    player_name = row.at_xpath('td[3]').text.strip.to_nil rescue nil
    #    hometown = row.at_xpath('td[4]').text.strip.to_nil rescue nil
    #    state = row.at_xpath('td[5]').text.strip.to_nil rescue nil
    #    highschool = row.at_xpath('td[6]').text.strip.to_nil rescue nil
    #    hs_state = row.at_xpath('td[7]').text.strip.to_nil rescue nil
    #    hs_position = row.at_xpath('td[8]').text.strip.to_nil rescue nil
    #    status = row.at_xpath('td[9]').text.strip.to_nil rescue nil
    #    lp_team_name = row.at_xpath('td[10]').text.strip.to_nil rescue nil

#lp = [recruit_id,	player_name,	hometown,	state,	highschool,	hs_state,	hs_Position,	status,	lp_team_name]




      #STDOUT.flush
