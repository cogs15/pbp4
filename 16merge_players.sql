use `ncaa_lacrosse`;

update ncaa_box_scores box
left JOIN
(select game_id, game_date, year
from ncaa_schedules b
) sched on sched.game_id = box.game_id
set box.game_date = sched.game_date,
box.year = sched.year;


#drop table if exists `ncaa_player_stats`;

create table if not exists `ncaa_player_stats` (
  `year` int(11) DEFAULT NULL,
  `team_id` int(11) NOT NULL,
  `team_name` varchar(255) NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `player_name` varchar(255) DEFAULT NULL,
  `player_code` varchar(255) DEFAULT NULL,
  `jersey_number` int(11) NOT NULL,
  `class_year` varchar(255) NOT NULL,
  `position` varchar(255) NOT NULL,
  `town` varchar(255) NOT NULL,
  `height` int(11) NOT NULL,
  `weight` int(11) NOT NULL,
  `gp` int(11) NOT NULL,
  `goals` int(11) NOT NULL,
  `assists` int(11) NOT NULL,
  `shots` int(11) NOT NULL,
  `sog` int(11) NOT NULL,
  `turnovers` int(11) NOT NULL,
  `g_sv` decimal(11,3) DEFAULT NULL,
  `a_to` decimal(11,3) DEFAULT NULL,
  `assisted_goal_pct` decimal(11,3) DEFAULT NULL,
  `assisted_goals` int(11) NOT NULL,
  `caused_turnover` int(11) NOT NULL,
  `gb` int(11) NOT NULL,
  `fow` int(11) NOT NULL,
  `fot` int(11) NOT NULL,
  `fow_pct` decimal(11,3) DEFAULT NULL,
  `violation_pct` decimal(11,3) DEFAULT NULL,
  `fow_gb_pct` decimal(11,3) DEFAULT NULL,
  `fogo_gb_pct` decimal(11,3) DEFAULT NULL,
  `fogo_gb` int(11) NOT NULL,
  `fogo_loss_gb` int(11) NOT NULL,
  `fow_violation` int(11) NOT NULL,
  `fol_violation` int(11) NOT NULL,
  `wing_gb` int(11) NOT NULL,
  `save_pct` decimal(11,3) DEFAULT NULL,
  `save_end_pct` decimal(11,3) DEFAULT NULL,
  `save_clean_pct` decimal(11,3) DEFAULT NULL,
  `clear_turnovers` int(11) NOT NULL,
  `emo_goals` int(11) NOT NULL,
  `emo_assists` int(11) NOT NULL,
  `emo_shots` int(11) NOT NULL,
  `emo_sog` int(11) NOT NULL,
  `emo_turnovers` int(11) NOT NULL,
  `unsettled_goals` int(11) NOT NULL,
  `unsettled_assists` int(11) NOT NULL,
  `unsettled_shots` int(11) NOT NULL,
  `unsettled_sog` int(11) NOT NULL,
  `unsettled_turnovers` int(11) NOT NULL,
  `saves` int(11) NOT NULL,
  `clean_saves` int(11) NOT NULL,
  `saves_end` int(11) NOT NULL,
  `goals_allowed` int(11) NOT NULL

) ENGINE=InnoDB DEFAULT CHARSET=utf8;


truncate `ncaa_player_stats`;

insert into `ncaa_player_stats` (year, team_id, team_name, player_id, player_name, jersey_number, class_year, position, town, height, weight)
select roster.year, roster.team_id, roster.team_name, roster.player_id, roster.player_name, roster.jersey_number, roster.class_year, roster.position, roster.town, roster.height, roster.weight
from ncaa_rosters roster;

update ncaa_player_stats
  set player_code = replace(player_name, ", jr", "");

  update ncaa_player_stats
  set player_code =  concat(team_id, left(split_part(player_code, ', ',1),4),left(split_part(player_code, ', ',2),2));



update ncaa_player_stats p
left JOIN
(select sum(b.goals) sumGoals, sum(b.assists) sumAssists, sum(b.shots) sumShots, sum(b.SOG) sumSOG, sum(b.turnovers) sumTurnovers, sum(b.GB) sumGB, sum(b.CT) sumCT, sum(b.fow) sumfow, sum(b.fo_taken) sumFOT, sum(b.saves) sumSaves, sum(b.goals_allowed) sumgoals_allowed, count(b.player_id) games, b.player_id, b.year
from ncaa_box_scores b
group by b.player_id, b.year
) box on box.player_id = p.player_id and box.year=p.year
set p.goals = box.sumGoals,
p.GP = box.games,
p.assists = box.sumAssists,
p.g_sv = box.sumGoals/(box.sumSOG-box.sumGoals),
p.a_to = box.sumAssists/box.sumTurnovers,
p.shots = box.sumShots,
p.SOG = box.sumSOG,
p.turnovers = box.sumTurnovers,
p.caused_turnover = box.sumCT,
p.fow = box.sumfow,
p.fot = box.sumfot,
p.fow_pct = box.sumfow/box.sumfot,
p.save_pct = box.sumSaves/(box.sumgoals_allowed + box.sumSaves),
p.GB = box.sumGB,
p.saves = box.sumSaves,
p.goals_allowed= box.sumgoals_allowed;


update ncaa_player_stats p
left JOIN
(select sum(b.clear_turnover) sumclear_turnover, b.turnover_player_code, b.team_id, b.year
from ncaa_merged_pbp b
where b.clear_turnover=1
group by b.turnover_player_code, b.year
) pbp on pbp.turnover_player_code = p.player_code and pbp.team_id = p.team_id  and pbp.year=p.year
set p.clear_turnovers = pbp.sumclear_turnover;



update ncaa_player_stats p
left JOIN
(select sum(b.goal) sumGoals, sum(b.shot) sumShots, sum(b.saved_shot) sumSaved_shot, b.shot_player_code, b.team_id, b.year
from ncaa_merged_pbp b
where b.emo=1
group by b.shot_player_code, b.year
) pbp on pbp.shot_player_code = p.player_code and pbp.team_id = p.team_id  and pbp.year=p.year
set p.emo_goals = pbp.sumGoals,
p.emo_shots = pbp.sumShots,
p.emo_sog = coalesce(pbp.sumSaved_shot + pbp.sumGoals, pbp.sumSaved_shot, pbp.sumGoals);



update ncaa_player_stats p
left JOIN
(select sum(b.goal) sumGoals, sum(b.shot) sumShots, sum(b.saved_shot) sumSaved_shot, b.shot_player_code, b.team_id, b.year
from ncaa_merged_pbp b
where b.unsettled=1
group by b.shot_player_code, b.year
) pbp on pbp.shot_player_code = p.player_code and pbp.team_id = p.team_id  and pbp.year=p.year
set p.unsettled_goals = pbp.sumGoals,
p.unsettled_shots = pbp.sumShots,
p.unsettled_sog = coalesce(pbp.sumSaved_shot + pbp.sumGoals, pbp.sumSaved_shot, pbp.sumGoals);


update ncaa_player_stats p
left JOIN
(select sum(b.assist) sumAssists, b.assist_player_code, b.team_id, b.year
from ncaa_merged_pbp b
where b.emo=1
group by b.assist_player_code, b.year
) pbp on pbp.assist_player_code = p.player_code and pbp.team_id = p.team_id  and pbp.year=p.year
set p.emo_assists = pbp.sumAssists;

update ncaa_player_stats p
left JOIN
(select sum(b.assist) sumAssists, b.assist_player_code,  b.team_id
from ncaa_merged_pbp b
where b.unsettled=1
group by b.assist_player_code, b.year
) pbp on pbp.assist_player_code = p.player_code and pbp.team_id = p.team_id
set p.unsettled_assists = pbp.sumAssists;


update ncaa_player_stats p
left JOIN
(select sum(b.turnover) sumTurnover, b.turnover_player_code, b.team_id, b.year
from ncaa_merged_pbp b
where b.emo=1
group by b.turnover_player_code, b.year
) pbp on pbp.turnover_player_code = p.player_code and pbp.team_id = p.team_id  and pbp.year=p.year
set p.emo_turnovers = pbp.sumTurnover;

update ncaa_player_stats p
left JOIN
(select sum(b.turnover) sumTurnover, b.turnover_player_code, b.team_id, b.year
from ncaa_merged_pbp b
where b.unsettled=1
group by b.turnover_player_code, b.year
) pbp on pbp.turnover_player_code = p.player_code and pbp.team_id = p.team_id  and pbp.year=p.year
set p.unsettled_turnovers = pbp.sumTurnover;


update ncaa_player_stats p
left JOIN
(select sum(b.fogo_gb) sumFogo, b.fow_player_code, b.team_id, b.year
from ncaa_merged_pbp b
where b.fogo_gb=1
group by b.fow_player_code, b.year
) pbp on pbp.fow_player_code = p.player_code and pbp.team_id = p.team_id  and pbp.year=p.year
set p.fogo_gb = pbp.sumFogo;

update ncaa_player_stats p
left JOIN
(select sum(b.fogo_gb) sumFogo, b.fol_player_code, b.opponent_id, b.year
from ncaa_merged_pbp b
where b.fogo_gb=1
group by b.fol_player_code, b.year
) pbp on pbp.fol_player_code = p.player_code and pbp.opponent_id = p.team_id  and pbp.year=p.year
set p.fogo_loss_gb = pbp.sumFogo;

update ncaa_player_stats p
left JOIN
(select sum(b.fo_violation) sumfo_violation, b.fow_player_code, b.team_id, b.year
from ncaa_merged_pbp b
where b.fo_violation=1
group by b.fow_player_code, b.year
) pbp on pbp.fow_player_code = p.player_code and pbp.team_id = p.team_id  and pbp.year=p.year
set p.fow_violation = pbp.sumfo_violation;

update ncaa_player_stats p
left JOIN
(select sum(b.fo_violation) sumfo_violation, b.fol_player_code, b.opponent_id, b.year
from ncaa_merged_pbp b
where b.fo_violation=1
group by b.fol_player_code, b.year
) pbp on pbp.fol_player_code = p.player_code and pbp.opponent_id = p.team_id  and pbp.year=p.year
set p.fol_violation = pbp.sumfo_violation;

update ncaa_player_stats p
left JOIN
(select sum(b.wing_gb) sumwing, b.gb_player_code, b.team_id, b.year
from ncaa_merged_pbp b
where b.wing_gb=1
group by b.gb_player, b.year
) pbp on pbp.gb_player_code = p.player_code and pbp.team_id = p.team_id  and pbp.year=p.year
set p.wing_gb = pbp.sumwing;


update ncaa_player_stats p
left JOIN
(select sum(b.wing_gb) sumwing, b.gb_player_code, b.team_id, b.year
from ncaa_merged_pbp b
where b.wing_gb=1
group by b.gb_player_code, b.year
) pbp on pbp.gb_player_code = p.player_code and pbp.team_id = p.team_id  and pbp.year=p.year
set p.wing_gb = pbp.sumwing;


update ncaa_player_stats p
left JOIN
(select sum(b.saved_shot_end) sumend, sum(b.saved_shot_clean) sumclean, b.opp_goalie, b.team_id, b.year, b.opponent_id
from ncaa_merged_pbp b
where b.saved_shot=1
group by b.opp_goalie, b.year
) pbp on pbp.opp_goalie = p.player_name and pbp.opponent_id = p.team_id  and pbp.year=p.year
set p.clean_saves = pbp.sumclean,
p.saves_end = pbp.sumend;


update ncaa_player_stats
set fow_gb_pct = fogo_gb/(fow-fow_violation),
fogo_gb_pct = fogo_gb/(fogo_gb + fogo_loss_gb),
violation_pct = fow_violation/(fow_violation+fol_violation),
save_end_pct = saves_end/saves,
save_clean_pct = clean_saves/saves;

update ncaa_player_stats p
left JOIN
(select sum(b.goal) sumAssisted, b.shot_player_code, b.team_id, b.year
from ncaa_merged_pbp b
where b.assist=1
group by b.shot_player_code, b.year
) pbp on pbp.shot_player_code = p.player_code and pbp.team_id = p.team_id  and pbp.year=p.year
set p.assisted_goals = pbp.sumAssisted;


update ncaa_player_stats
set assisted_goal_pct = assisted_goals/goals;
