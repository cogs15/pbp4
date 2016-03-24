use `ncaa_lacrosse`;

create table if not exists `ncaa_merged_pbp` (
  `merge_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
  `team_id` INT(11) NOT NULL,
  `team_name` VARCHAR(255) NOT NULL,
  `opponent_id` INT(11) NOT NULL,
  `opponent_name` VARCHAR(255) NOT NULL,
  `game_id` INT(11) NOT NULL,
  `year` INT(11) NOT NULL,
    `game_date` VARCHAR(255) NOT NULL,
  `period_id` INT(11) NOT NULL,
  `time` VARCHAR(255) NOT NULL,
    `section_id` INT(11) NOT NULL,
  `event_id` INT(11) NOT NULL,
  `play_text` VARCHAR(1000) DEFAULT ""
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
