
#!/usr/bin/env ruby

require 'csv'
require './lib/mysql_client.rb'
require './lib/http_client.rb'

mysql_client = MySQLClient.new
http_client = HttpClient.new

year = ARGV[0]
division =  ARGV[1]



# Base URL for relative team links

base_url = 'http://stats.ncaa.org'


year_division_url = "http://stats.ncaa.org/team/inst_team_list?&academic_year=#{year}&conf_id=-1&division=#{division}&sport_code=MLA"

puts "\nRetrieving division #{division} teams for #{year} ... "


found_teams = 0

doc = http_client.get_html(year_division_url)

doc.search("a").each do |link|
ncaa_teams = []
  link_url = link.attributes["href"].text

  # Valid team URLs

  if (link_url =~ /^\/team\/\d/)

    # NCAA year_id

    parameters = link_url.split("/")
    year_id = parameters[-1]

    # NCAA team_id

    team_id = parameters[-2]

    # NCAA team name

    team_name = link.text()

    # NCAA team URL

    team_url = base_url+link_url
    ncaa_teams += [year, year_id, division, team_id, team_name, team_url]



        mysql_client.write_teams(ncaa_teams)
    found_teams += 1

  end




end




puts "found #{found_teams} teams\n\n"
      STDOUT.flush
