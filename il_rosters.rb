#!/usr/bin/env ruby

require 'csv'

require './lib/mysql_client.rb'
require './lib/http_client.rb'

mysql_client = MySQLClient.new
http_client = HttpClient.new

#year = ARGV[0]
#division = 1

# Base URL for relative team links



teams = CSV.read("tsv/IL_schools.csv")

first_year = 14
last_year = 14

(first_year..last_year).each do |year|

  teams.each do |team|

    team_id = team[0]
    team_name = team[1]
    print "#{year}/#{team_name}\n"

      team_roster_url = "http://www.insidelacrosse.com/team/#{team_id}/#{year}"


        doc = http_client.get_html(team_roster_url)

    doc.xpath("/html/body/main/div/div[2]/div/table[1]/tbody/tr").each do |row|
xx
r = [year, team_name,team_id]
      row.xpath("td").each_with_index do |d,i|
          r += [d.text.strip]

end


  mysql_client.write_rosters(r)

      end

      STDOUT.flush
end
end
