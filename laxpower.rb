#!/usr/bin/env ruby

require 'csv'

require './lib/mysql_client.rb'
require './lib/http_client.rb'

mysql_client = MySQLClient.new
http_client = HttpClient.new

#year = ARGV[0]
#division = 1

# Base URL for relative team links

first_year = 2007
last_year = 2018

(first_year..last_year).each do |year|

for i in (1..150).step(1) do


    #  team_roster_url = "http://laxpower.com/recruits/recruits.php?action=viewRcd&db=recruits2017&q=&page=1"

team_roster_url = "http://laxpower.com/recruits/recruits.php?action=viewRcd&db=recruits#{year}&q=&page=#{i}"

#roster_xpath = "//*[@id='grid']/table/tr[position>2]"



        doc = http_client.get_html(team_roster_url)


    doc.xpath("//*[@id='grid']/table/tr").each do |row|


      table = row.parent

      recruit_id =  row.at_xpath('td[1]').text.strip rescue nil
      division =  row.at_xpath('td[2]').text.strip rescue nil
      player_name =  row.at_xpath('td[3]').text.strip rescue nil
      hometown =  row.at_xpath('td[4]').text.strip rescue nil
      state =  row.at_xpath('td[5]').text.strip rescue nil
      highschool =  row.at_xpath('td[6]').text.strip rescue nil
      hs_state =  row.at_xpath('td[7]').text.strip rescue nil
hs_position =  row.at_xpath('td[8]').text.strip rescue nil
status =  row.at_xpath('td[9]').text.strip rescue nil
lp_team_name =  row.at_xpath('td[10]').text.strip rescue nil
          r = [year, recruit_id, division,	player_name,	hometown,	state,	highschool,	hs_state,	hs_position,	status,	lp_team_name]




  mysql_client.write_laxpower(r)
end


      STDOUT.flush
end
end
