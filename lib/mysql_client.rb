require 'mysql2'

class MySQLClient

  def initialize()
    if not ENV.key?('MYSQL_HOST') or
      not ENV.key?('MYSQL_USERNAME') or
      not ENV.key?('MYSQL_PASSWORD')

      puts "ERROR! `MYSQL_HOST`, `MYSQL_USERNAME`, and "+
        "`MYSQL_PASSWORD` must be specified!"
      throw :die
    end

    @client = Mysql2::Client.new(
      :host => ENV["MYSQL_HOST"],
      :username => ENV["MYSQL_USERNAME"],
      :password => ENV["MYSQL_PASSWORD"]
    )
  end

  def write_schedule(row)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`ncaa_schedules`
       (year, year_id, team_id, team_name, game_date,
        game_string, opponent_id, opponent_name,
        opponent_url, neutral_site, neutral_location,
        home_game, score_string, team_won, score, exempt,
        team_score, opponent_score, overtime, overtime_periods,
        game_id, game_url)
        VALUES
       (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
        ?, ?, ?, ?)
      ")

      statement.execute(*row)
  end

  def get_unique_game_ids()
    to_return = []

    results = @client.query(
      "SELECT DISTINCT `game_id`
       FROM `ncaa_lacrosse`.`ncaa_schedules`
       WHERE `game_id` IS NOT NULL
      ")

    results.each do |row|
      to_return.push(row['game_id'])
    end

    to_return.sort!
    to_return.uniq!
    
    return to_return
  end

end
