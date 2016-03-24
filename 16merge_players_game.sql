use `ncaa_lacrosse`;

drop table `ncaa_player_game_stats`;

CREATE TABLE if not exists `ncaa_player_game_stats` (
  `year` int(11) DEFAULT NULL,
  `game_date` varchar(255) DEFAULT NULL,
  `game_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL,
  `team_name` varchar(255) DEFAULT NULL,
  `opponent_id` int(11) DEFAULT NULL,
  `opponent_name` varchar(255) DEFAULT NULL,
  `player_id` int(11) DEFAULT NULL,
  `player_name` varchar(255) DEFAULT NULL,
  `start_position` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `goals` int(11) DEFAULT NULL,
  `assists` int(11) DEFAULT NULL,
  `points` int(11) DEFAULT NULL,
  `shots` int(11) DEFAULT NULL,
  `sog` int(11) DEFAULT NULL,
  `emo_g` int(11) DEFAULT NULL,
  `gb` int(11) DEFAULT NULL,
  `turnovers` int(11) DEFAULT NULL,
  `ct` int(11) DEFAULT NULL,
  `fow` int(11) DEFAULT NULL,
  `fo_taken` int(11) DEFAULT NULL,
  `pen` int(11) DEFAULT NULL,
  `pen_time` varchar(255) DEFAULT NULL,
  `g_min` varchar(255) DEFAULT NULL,
  `goals_allowed` int(11) DEFAULT NULL,
  `saves` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

truncate `ncaa_player_game_stats`;

insert into `ncaa_player_game_stats` (year, game_date, game_id, section_id, player_id, player_name, start_position, goals, assists, points, shots, sog, emo_g, gb, turnovers, ct, fow, fo_taken, pen, pen_time, g_min, goals_allowed, saves)
select b.year, b.game_date, b.game_id, b.section_id,  b.player_id, b.player_name, b.position as start_position, b.goals, b.assists, b.points, b.shots, b.sog, b.emo_g, b.gb, b.to as turnovers, b.ct, b.fow, b.fo_taken, b.pen, b.pen_time, b.g_min, b.goals_allowed, b.saves
from ncaa_box_scores b
where b.player_name<>'TOTALS' and b.player_name<>'Team';




           update ncaa_player_game_stats t1, (select game_id, team_id, section_id from ncaa_periods) t2
          set t1.team_id = t2.team_id
          where t1.game_id=t2.game_id and t1.section_id = t2.section_id;

          update ncaa_player_game_stats t1, (select game_id, team_id, section_id from ncaa_periods) t2
         set t1.opponent_id = t2.team_id
         where t1.game_id=t2.game_id and t1.section_id = 1-t2.section_id;

         update ncaa_player_game_stats t1, (select team_id, team_name, year from ncaa_rosters) t2
        set t1.team_name = t2.team_name
        where t1.team_id=t2.team_id and t1.year=t2.year;

        update ncaa_player_game_stats t1, (select team_id, team_name, year from ncaa_rosters) t2
       set t1.opponent_name = t2.team_name
       where t1.opponent_id=t2.team_id and t1.year=t2.year;

       update ncaa_player_game_stats t1, (select player_id, position, year from ncaa_player_stats) t2
      set t1.position = t2.position
      where t1.player_id=t2.player_id and t1.year=t2.year and t1.start_position='""';

      update ncaa_player_game_stats
        set position=start_position
        where start_position<>'""';

        update ncaa_player_game_stats
          set position=left(position,1);
