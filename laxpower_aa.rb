#!/usr/bin/env ruby

require './lib/mysql_client.rb'
require './lib/http_client.rb'

mysql_client = MySQLClient.new
http_client = HttpClient.new

first_year = 2000
last_year = 2016

(first_year..last_year).each do |year|


team_roster_url = "http://www.laxpower.com/all-amer/aa-list-college.php?year=#{year}&division=MD1"

        doc = http_client.get_html(team_roster_url)

    doc.xpath("//*[@id='content_well']/table/tr").each do |row|

table = row.parent

aa_team =  row.at_xpath('td[1]').text.strip rescue nil
position =  row.at_xpath('td[2]').text.strip rescue nil
player_name =  row.at_xpath('td[3]').text.strip rescue nil
lp_team_name =  row.at_xpath('td[4]').text.strip rescue nil

r = [year, aa_team, position, player_name, lp_team_name]

  mysql_client.write_aa(r)
end
end


        STDOUT.flush
