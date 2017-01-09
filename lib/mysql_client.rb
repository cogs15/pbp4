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

  def write_teams(ncaa_teams)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`ncaa_teams`
       (year, year_id, division, team_id, team_name, team_url)
        VALUES
       (?, ?, ?, ?, ?, ?)
      ")

      statement.execute(*ncaa_teams)
  end

  def write_box(ncaa_box_scores)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`ncaa_box_scores`
       (game_id, section_id, player_id, player_name, player_url, position, Goals,	Assists,	Points,	Shots,	SOG,	emo_G,	Man_Down_G,	GB,	turnovers,	CT,	FOW,	fo_Taken,	Pen,	Pen_Time,	G_Min,	Goals_Allowed,	Saves,	W,	L,	T,	RC,	YC,	Clears_suc, Clears_Att,	Clear_Pct)
        VALUES
       (?, ?, ?, ?, ?, ?,
       ?, ?, ?, ?, ?, ?,
       ?, ?, ?, ?, ?, ?,
       ?, ?, ?, ?, ?, ?,
       ?, ?, ?, ?, ?, ?, ?
       )
      ")
          statement.execute(*ncaa_box_scores)
      end

  #    def write_box(ncaa_box_scores)
  #      statement = @client.prepare(
  #        "REPLACE INTO `ncaa_lacrosse`.`ncaa_box_scores_2010`
  #         (game_id, section_id, player_id, player_name, player_url, position, Goals,	Assists,	Points,	Shots,	SOG,	emo_G,	Man_Down_G,	GB,	turnovers,	CT,	FOW,	fo_Taken,	Pen,	Pen_Time,	G_Min,	Goals_Allowed,	Saves,	W,	L,	T,	RC,	YC)
  #          VALUES
  #         (?, ?, ?, ?, ?, ?,
  #         ?, ?, ?, ?, ?, ?,
  #         ?, ?, ?, ?, ?, ?,
  #         ?, ?, ?, ?, ?, ?,
  #         ?, ?, ?, ?
  #         )
  #        ")


  def write_pbp(ncaa_play_by_play)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`ncaa_pbp`
      (game_id, period_id, event_id, time, raw_time,
                            team_text, team_score,
                            opponent_score, score,
                            opponent_text
                            )
    VALUES
       (?, ?, ?, ?, ?, ?,
       ?, ?, ?, ?
       )
      ")

      statement.execute(*ncaa_play_by_play)
  end

  def write_periods(ncaa_periods)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`ncaa_periods`
      (game_id, section_id, team_id, team_name, team_url, period_scores)
    VALUES
       (?, ?, ?, ?, ?, ?
       )
      ")

      statement.execute(*ncaa_periods)
  end

  def write_rosters(row)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`ncaa_rosters`
      (year, year_id, team_id, team_name, jersey_number,
                            player_id, player_name, player_url,
                            class_year,
                            games_played, games_started)
    VALUES
       (?, ?, ?, ?, ?, ?,
       ?, ?, ?, ?, ?
       )
      ")

      statement.execute(*row)
  end

  def write_laxpower(r)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`laxpower_database`
      (year, recruit_id, division,	player_name,	hometown,	state,	highschool,	hs_state,	hs_position,	status,	lp_team_name)
    VALUES
       (?, ?, ?, ?, ?, ?, ?,
       ?, ?, ?, ?
       )
      ")

      statement.execute(*r)
  end

  def write_demographics(r)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`demographics`
      (jersey_number)
    VALUES
       (?
       )
      ")

      statement.execute(*r)
  end


  def write_aa(r)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`all_americans`
      (year, aa_team, position, player_name, lp_team_name)
    VALUES
       (?, ?, ?, ?, ?
       )
      ")

      statement.execute(*r)
  end

  def write_rosters_2(r)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`insidelacrosse_database`
      (year, team_name,team_id, jersey,	Name,	Pos,	Yr,	Hometown,	G,	A,	P)
    VALUES
       (?, ?, ?, ?, ?, ?,
       ?, ?, ?, ?, ?
       )
      ")

      statement.execute(*r)
  end

  def write_twitter(r)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`twitter_data`
      (date_year, twitter_handle, followers)
    VALUES
       (?, ?, ?
       )
      ")

      statement.execute(*r)
  end

  def write_instagram(r)
    statement = @client.prepare(
      "REPLACE INTO `ncaa_lacrosse`.`instagram_data`
      (date_year, instagram_handle, followers)
    VALUES
       (?, ?, ?
       )
      ")

      statement.execute(*r)
  end

  def get_unique_game_ids()
    to_return = []

    results = @client.query(
      "SELECT DISTINCT `game_id`
       FROM `ncaa_lacrosse`.`ncaa_schedules`
       WHERE `game_id` IS NOT NULL and year>2013
      ")
    results.each do |row|
      to_return.push(row['game_id'])
    end

    to_return.sort!
    to_return.uniq!

    return to_return
  end

  def get_twitter()
    to_return = []

    results = @client.query(
      "SELECT DISTINCT `twitter_handle`
       FROM `ncaa_lacrosse`.`team_dictionary`
       WHERE `twitter_handle` IS NOT NULL
      ")

    results.each do |row|
      to_return.push(row['twitter_handle'])
    end

    to_return.sort!
    to_return.uniq!

    return to_return
  end

  def get_team_pages()
    to_return = []

    results = @client.query(
      "SELECT DISTINCT `roster_url`
       FROM `ncaa_lacrosse`.`ncaa_team_websites`
       WHERE `roster_url` IS NOT NULL
      ")

    results.each do |row|
      to_return.push(row['roster_url'])
    end

    to_return.sort!
    to_return.uniq!

    return to_return
  end


  def get_instagram()
    to_return = []

    results = @client.query(
      "SELECT DISTINCT `instagram_handle`
       FROM `ncaa_lacrosse`.`team_dictionary`
       WHERE `instagram_handle` IS NOT NULL
      ")

    results.each do |row|
      to_return.push(row['instagram_handle'])
    end

    to_return.sort!
    to_return.uniq!

    return to_return
  end

  def get_team_ids()
    team_return = []

    results = @client.query(
      "SELECT `year`, `year_id`, `division`, `team_id`, `team_name`
       FROM `ncaa_lacrosse`.`ncaa_teams`
       WHERE `team_id` IS NOT NULL
      ")

    results.each do |row|
      team_return.push([row["year"], row["year_id"], row["division"],
        row["team_id"], row["team_name"]])
    end

    return team_return
  end



end
