#!/usr/bin/env ruby

require 'csv'

require './lib/mysql_client.rb'
require './lib/http_client.rb'

mysql_client = MySQLClient.new
http_client = HttpClient.new

nthreads = 1

year = 2016
division = ARGV[0]

# Base URL for relative team links

base_url = 'http://stats.ncaa.org'

roster_xpath = '//*[@id="stat_grid"]/tbody/tr'

ncaa_teams = CSV.open("tsv/ncaa_teams_#{year}.tsv",
                      "r",
                      {:col_sep => "\t", :headers => TRUE})


#http://stats.ncaa.org/team/roster/11540?org_id=2

# Header for team file

# Get team IDs

teams = []
ncaa_teams.each do |team|
  teams << team
end

n = teams.size

tpt = (n.to_f/nthreads.to_f).ceil

threads = []

teams.each_slice(tpt).with_index do |teams_slice,i|

  threads << Thread.new(teams_slice) do |t_teams|

    t_teams.each_with_index do |team,j|

      year = team[0]
      year_id = team[1]
      team_id = team[3]
      team_name = team[4]

      team_roster_url = "http://stats.ncaa.org/team/#{team_id}/roster/#{year_id}"
      doc = http_client.get_html(team_roster_url)

      found_players = 0
      missing_id = 0

      puts "#{i} #{year} #{team_name} ..."


      doc.xpath(roster_xpath).each do |player|

        row = [year, year_id, team_id, team_name]
        player.xpath("td").each_with_index do |element,k|
          case k
          when 1
            player_name = element.text.strip

            link = element.search("a").first
            if (link==nil)
              missing_id += 1
              link_url = nil
              player_id = nil
              player_url = nil
            else
              link_url = link.attributes["href"].text
              parameters = link_url.split("/")[-1]

              # player_id

              player_id = parameters.split("=")[2]

              # opponent URL

              player_url = base_url+link_url
            end

            found_players += 1
            row += [player_id, player_name, player_url]
          else
            field_string = element.text.strip

            row += [field_string]

          end


        end


  mysql_client.write_rosters(row)

      end

      puts " #{found_players} players, #{missing_id} missing ID\n"
      STDOUT.flush
    end

  end

end

threads.each(&:join)
