
#!/usr/bin/env ruby

require 'csv'
require './lib/http_client.rb'

http_client = HttpClient.new

year = 2016
division =  ARGV[0]

ncaa_teams = CSV.open("tsv/ncaa_teams_#{year}_#{division}.tsv",
                      "w",
                      {:col_sep => "\t"})

# Header for team file

ncaa_teams << ["year", "year_id", "division",
               "team_id", "team_name", "team_url"]

# Base URL for relative team links

base_url = 'http://stats.ncaa.org'


year_division_url = "http://stats.ncaa.org/team/inst_team_list?&academic_year=#{year}&conf_id=-1&division=#{division}&sport_code=MLA"

puts "\nRetrieving division #{division} teams for #{year} ... "

found_teams = 0

doc = http_client.get_html(year_division_url)

doc.search("a").each do |link|

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

    ncaa_teams << [year, year_id, division, team_id, team_name, team_url]
    found_teams += 1

  end

  ncaa_teams.flush

end

ncaa_teams.close

puts "found #{found_teams} teams\n\n"
