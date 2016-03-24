#!/usr/bin/env ruby

require 'csv'

require './lib/mysql_client.rb'
require './lib/http_client.rb'

mysql_client = MySQLClient.new
http_client = HttpClient.new

nthreads = 1

year = 2016

#require 'awesome_puts'

class String
  def to_nil
    self.empty? ? nil : self
  end
end

base_url = 'http://stats.ncaa.org'

box_scores_xpath = '//*[@id="contentarea"]/table[position()>4]/tr[position()>2]'


# Headers


# Get game IDs
mysql_client = MySQLClient.new
game_ids = mysql_client.get_unique_game_ids()

n = game_ids.size

gpt = (n.to_f/nthreads.to_f).ceil

threads = []

game_ids.each_slice(gpt).with_index do |ids,i|

  threads << Thread.new(ids) do |t_ids|

    found = 0
    n_t = t_ids.size

      ncaa_box_scores = []
    t_ids.each_with_index do |game_id,j|

      game_url = 'http://stats.ncaa.org/game/box_score/%d' % [game_id]
      page = http_client.get_html(game_url)

      found += 1

      puts "#{i}, #{game_id} : #{j+1}/#{n_t}; found #{found}/#{n_t}\n"

      page.xpath(box_scores_xpath).each do |row|

        table = row.parent
        section_id = table.parent.xpath('table[position()>1 and @class="mytable"]').index(table)

        player_id = nil
        player_name = nil
        player_url = nil

        field_values = []
        row.xpath('td').each_with_index do |element,k|

          case k
          when 0
            player_name = element.text.strip rescue nil
            link = element.search("a").first

            if not(link.nil?)
              link_url = link.attributes["href"].text
              player_url = base_url+link_url
              parameters = link_url.split("/")[-1]
              player_id = parameters.split("=")[2]
            end
          else
            field_values += [element.text.strip]
            #field_values += [element.text.strip.to_i]
          end
        end

        ncaa_box_scores = [game_id,section_id,player_id,player_name,player_url]+field_values

        mysql_client.write_box(ncaa_box_scores)
      end

    end

  end

end

threads.each(&:join)
