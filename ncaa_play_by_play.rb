#!/usr/bin/env ruby

require 'csv'

require './lib/mysql_client.rb'
require './lib/http_client.rb'

http_client = HttpClient.new

nthreads = 1

year = 2016
division = ARGV[0]

# Base URL

base_url = 'http://stats.ncaa.org'

#require 'awesome_puts'

class String
  def to_nil
    self.empty? ? nil : self
  end
end


play_xpath = '//table[position()>1 and @class="mytable"]/tr[position()>1]'
#periods_xpath = '//*[@id="contentarea"]/table[1]/tr[position()>1]'
periods_xpath = '//table[position()=1 and @class="mytable"]/tr[position()>1]'

ncaa_play_by_play = CSV.open("tsv/ncaa_games_play_by_play_mt_#{year}_#{division}.tsv",
                             "w",
                             {:col_sep => "\t"})
ncaa_periods = CSV.open("tsv/ncaa_games_periods_mt_#{year}_#{division}.tsv",
                        "w",
                        {:col_sep => "\t"})

# Headers

ncaa_play_by_play << ["game_id", "period_id", "event_id", "time", "raw_time",
                      "team_text", "team_score",
                      "opponent_score", "score",
                      "opponent_text"]

ncaa_periods << ["game_id", "section_id", "team_id", "team_name", "team_url",
                 "period_scores"]

# Get game IDs
mysql_client = MySQLClient.new
game_ids = mysql_client.get_unique_game_ids()

#game_ids = game_ids[0..199]

n = game_ids.size

gpt = (n.to_f/nthreads.to_f).ceil

threads = []

game_ids.each_slice(gpt).with_index do |ids,i|

  threads << Thread.new(ids) do |t_ids|

    found = 0
    n_t = t_ids.size

    t_ids.each_with_index do |game_id,j|
      game_url = 'http://stats.ncaa.org/game/play_by_play/%d' % [game_id]
      page = http_client.get_html(game_url)

      found += 1

      puts "#{i}, #{game_id} : #{j+1}/#{n_t}; found #{found}/#{n_t}\n"

      page.xpath(play_xpath).each_with_index do |row,event_id|

        table = row.parent
        period_id = table.parent.xpath('table[position()>1 and @class="mytable"]').index(table)

        raw_time = row.at_xpath('td[1]').text.strip.to_nil rescue nil

        if not(raw_time==nil) and (raw_time.include?(":"))
          minutes = raw_time.split(":")[0]
          seconds = raw_time.split(":")[1]
          if (seconds.size==3)
            minutes = "1"+minutes
            seconds = seconds[0..1]
            time = minutes+":"+seconds
          else
            time = raw_time
          end
        else
          time = nil
        end

        team_text = row.at_xpath('td[2]').text.strip.to_nil rescue nil
        score = row.at_xpath('td[3]').text.strip.to_nil rescue nil
        opponent_text = row.at_xpath('td[4]').text.strip.to_nil rescue nil



        scores = score.split('-') rescue nil
        team_score = scores[0].strip rescue nil
        opponent_score = scores[1].strip rescue nil

#        ap [period_id,event_id,time,team_player,team_event,team_text,team_score,opponent_score,score,opponent_player,opponent_event,opponent_text]

        if not(time==nil) and (time.include?('End'))
          time = '00:00'
        end

        ncaa_play_by_play << [game_id,period_id,event_id,time,raw_time,team_text,team_score,opponent_score,score,opponent_text]

      end

      page.xpath(periods_xpath).each_with_index do |row,section_id|
        team_period_scores = []
#        section = [game_id,section_id]
        team_name = nil
        link_url = nil
        team_url = nil
        team_id = nil
        row.xpath('td').each_with_index do |element,i|
          case i
          when 0
            team_name = element.text.strip rescue nil
            link = element.search("a").first

            if not(link.nil?)
              link_url = link.attributes["href"].text
              team_url = base_url+link_url
              parameters = link_url.split("/")
              team_id = parameters[-2]
            end
#            section += [team_id, team_name, team_url]
          else
            team_period_scores += [element.text.strip.to_i]
          end
        end
        ncaa_periods << [game_id,section_id,team_id,team_name,team_url,team_period_scores]
      end
    end

  end

end

threads.each(&:join)

ncaa_play_by_play.close
