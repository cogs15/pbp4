#!/bin/bash

for i in `seq 1 3`;
do
  echo "Scraping schedules for division $i"
  ruby ncaa_team_schedules.rb "$i"

  echo "Scraping box scores for division $i"
  ruby ncaa_box_scores.rb "$i"

  echo "Scraping play-by-plays for division $i"
  ruby ncaa_play_by_play.rb "$i"
done
