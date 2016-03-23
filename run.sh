#!/bin/bash

for i in `seq 1`;
do
  #echo "Scraping team for division $i"
  #ruby ncaa_teams.rb "$i"

  echo "Scraping team rosters for division $i"
  ruby ncaa_team_rosters.rb "$i"

  echo "Scraping schedules for division $i"
  ruby ncaa_team_schedules.rb "$i"

  echo "Scraping box scores for division $i"
  ruby ncaa_box_scores.rb "$i"

  echo "Scraping play-by-plays for division $i"
  ruby ncaa_play_by_play.rb "$i"
done

#echo "Running roster update"
#mysql -u"$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -h"$MYSQL_HOST" < 16roster_update.sql

#echo "Running box scores merge"
#mysql -u"$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -h"$MYSQL_HOST" < 16merge_box.sql

#echo "Running pbp merge"
#mysql -u"$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -h"$MYSQL_HOST" < 16merge_pbp.sql

#echo "Running parse pbp"
#mysql -u"$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -h"$MYSQL_HOST" < 16parse_pbp.sql

#echo "Running players cumulative merge"
#mysql -u"$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -h"$MYSQL_HOST" < 16merge_players.sql

#echo "Running players game merge"
#mysql -u"$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -h"$MYSQL_HOST" < 16merge_players_game.sql
