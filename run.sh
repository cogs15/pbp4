#!/bin/bash

echo "Clearing table"
mysql -u"$MYSQL_USERNAME" -h"$MYSQL_HOST" < clear_tables.sql


#for i in `seq 1 3`;
#do
#  echo "Scraping team for division $i"
#  ruby ncaa_teams.rb "$i"

#done
  echo "Scraping team rosters"
  ruby ncaa_team_rosters.rb

  echo "Scraping schedules for division"
  ruby ncaa_team_schedules.rb


 echo "Scraping box scores"
  ruby ncaa_box_scores.rb

  echo "Scraping play-by-plays"
  ruby ncaa_play_by_play.rb


#echo "Running roster update"
#mysql -u"$MYSQL_USERNAME" -h"$MYSQL_HOST" < 16roster_update.sql

echo "Running pbp merge"
mysql -u"$MYSQL_USERNAME" -h"$MYSQL_HOST" < 16merge_pbp.sql

echo "Running parse pbp"
mysql -u"$MYSQL_USERNAME" -h"$MYSQL_HOST" < 16parse_pbp.sql

echo "Running box scores merge"
mysql -u"$MYSQL_USERNAME" -h"$MYSQL_HOST" < 16merge_box.sql

echo "Running players cumulative merge"
mysql -u"$MYSQL_USERNAME" -h"$MYSQL_HOST" < 16merge_players.sql

echo "Running players game merge"
mysql -u"$MYSQL_USERNAME" -h"$MYSQL_HOST" < 16merge_players_game.sql

echo "Running second parse"
mysql -u"$MYSQL_USERNAME" -h"$MYSQL_HOST" < 16merge_box2.sql

echo "Running rpi"
mysql -u"$MYSQL_USERNAME" -h"$MYSQL_HOST" < rpi.sql
