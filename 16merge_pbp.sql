use `ncaa_lacrosse`;

create table if not exists `ncaa_merged_pbp` (
  `merge_id` int(11) NOT NULL AUTO_INCREMENT,
  `team_id` int(11) NOT NULL,
  `team_name` varchar(255) NOT NULL,
  `opponent_id` int(11) NOT NULL,
  `opponent_name` varchar(255) NOT NULL,
  `game_id` int(11) NOT NULL,
  `year` int(11) DEFAULT NULL,
  `game_date` varchar(255) DEFAULT NULL,
  `period_id` int(11) NOT NULL,
  `time` varchar(255) DEFAULT NULL,
  `event_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `play_text` varchar(1000) DEFAULT '',
  `fow_player` varchar(255) DEFAULT NULL,
  `fol_player` varchar(255) DEFAULT NULL,
  `gb_player` varchar(255) DEFAULT NULL,
  `fow_player_code` varchar(255) DEFAULT NULL,
  `fol_player_code` varchar(255) DEFAULT NULL,
  `gb_player_code` varchar(255) DEFAULT NULL,
  `fogo_gb` int(11) DEFAULT NULL,
  `wing_gb` int(11) DEFAULT NULL,
  `fo_violation` int(11) DEFAULT NULL,
  `fow` int(11) DEFAULT NULL,
  `shot_player` varchar(255) DEFAULT NULL,
  `turnover_player` varchar(255) DEFAULT NULL,
  `shot_player_code` varchar(255) DEFAULT NULL,
  `turnover_player_code` varchar(255) DEFAULT NULL,
  `shot` int(11) DEFAULT NULL,
  `saved_shot` int(11) DEFAULT NULL,
  `saved_shot_end` int(11) DEFAULT NULL,
  `saved_shot_clean` int(11) DEFAULT NULL,
  `saved_shot_oreb` int(11) DEFAULT NULL,
  `saved_shot_dreb` int(11) DEFAULT NULL,
  `shot_off` int(11) DEFAULT NULL,
  `shot_off_end` int(11) DEFAULT NULL,
  `shot_turnover` int(11) DEFAULT NULL,
  `goal` int(11) DEFAULT NULL,
  `assist` int(11) DEFAULT NULL,
  `turnover` int(11) DEFAULT NULL,
  `assist_player` varchar(255) DEFAULT NULL,
  `assist_player_code` varchar(255) DEFAULT NULL,
  `adj_time` decimal(11,3) DEFAULT NULL,
  `time_elapsed` decimal(11,3) DEFAULT NULL,
  `total_time_elapsed` decimal(11,3) DEFAULT NULL,
  `game_time` decimal(11,3) DEFAULT NULL,
  `poss_time` decimal(11,3) DEFAULT NULL,
  `poss_start` int(11) DEFAULT NULL,
  `poss_number` int(11) DEFAULT NULL,
  `poss_end` int(11) DEFAULT NULL,
  `poss_end_mis` int(11) DEFAULT NULL,
  `EMO` int(11) DEFAULT NULL,
  `penalty` int(11) DEFAULT NULL,
  `penalty_length` varchar(255) DEFAULT NULL,
  `penalty_clock` decimal(11,3) DEFAULT NULL,
  `emo_team` varchar(255) DEFAULT NULL,
  `clear_good` int(11) DEFAULT NULL,
  `clear_fail` int(11) DEFAULT NULL,
  `fow_clear` int(11) DEFAULT NULL,
  `clear_turnover` int(11) DEFAULT NULL,
  `clear_to_gb` int(11) DEFAULT NULL,
  `clear_after_fail` int(11) DEFAULT NULL,
  `clear_to_offensive_end` int(11) DEFAULT NULL,
  `fow_turnover` int(11) DEFAULT NULL,
  `unsettled` int(11) DEFAULT NULL,
  `unsettled_off_clear` int(11) DEFAULT NULL,
  `unsettled_off_fow` int(11) DEFAULT NULL,
  `shot_position` varchar(11) DEFAULT NULL,
  `assist_position` varchar(11) DEFAULT NULL,
  `turnover_position` varchar(11) DEFAULT NULL,
  `goalie` varchar(255) DEFAULT NULL,
  `opp_goalie` varchar(255) DEFAULT NULL,
  `goalie_start` int(11) DEFAULT NULL,
  `goalie_change` int(11) DEFAULT NULL,
    PRIMARY KEY (`merge_id`)
  );

truncate `ncaa_merged_pbp`;

insert into `ncaa_merged_pbp` (team_id, team_name, opponent_id, opponent_name, game_id, period_id, time, section_id, event_id, play_text)
select periods.team_id, periods.team_name,
periods2.team_id as opponent_id, periods2.team_name as opponent_name,
pbp.game_id, pbp.period_id, pbp.time, periods.section_id, pbp.event_id, pbp.team_text as play_text
from ncaa_periods periods
left join ncaa_pbp pbp on periods.game_id=pbp.game_id
left join ncaa_periods periods2 on periods.game_id = periods2.game_id
where pbp.team_text != ""
and periods.section_id = 0
and periods2.section_id = 1
union
select periods.team_id, periods.team_name,
periods2.team_id as opponent_id, periods2.team_name as opponent_name,
pbp.game_id, pbp.period_id, pbp.time, periods.section_id, pbp.event_id, pbp.opponent_text as play_text
from ncaa_periods periods
left join ncaa_pbp pbp on periods.game_id=pbp.game_id
left join ncaa_periods periods2 on periods.game_id = periods2.game_id
where pbp.opponent_text != ""
and periods.section_id = 1
and periods2.section_id = 0;


update ncaa_merged_pbp pbp
left JOIN
(select game_id, game_date, year
from ncaa_schedules b
) sched on sched.game_id = pbp.game_id
set pbp.game_date = sched.game_date,
pbp.year = sched.year;
