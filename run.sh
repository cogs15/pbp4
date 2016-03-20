#!/bin/bash

scrape_division () {
  echo "Scraping schedules for division $1"
  ruby ncaa_team_schedules.rb "$1"

  echo "Scraping box scores for division $1"
  ruby ncaa_box_scores.rb "$1"

  echo "Scraping play-by-plays for division $1"
  ruby ncaa_play_by_play.rb "$1"
}

scrape_division 1
scrape_division 2
scrape_division 3
