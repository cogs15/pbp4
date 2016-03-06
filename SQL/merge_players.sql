update ncaa_box_scores box
left JOIN
(select game_id, game_date, year
from ncaa_schedule b
) sched on sched.game_id = box.game_id
set box.game_date = sched.game_date,
box.year = sched.year;




create table if not exists `ncaa_player_stats` (
  `year` int(11) DEFAULT NULL,
  `team_id` int(11) NOT NULL,
  `team_name` varchar(255) NOT NULL,
  `player_id` int(11) DEFAULT NULL,
  `player_name` varchar(255) DEFAULT NULL,
  `jersey_number` int(11) NOT NULL,
  `class_year` varchar(255) NOT NULL,
  `position` varchar(255) NOT NULL,
  `town` varchar(255) NOT NULL,
  `height` int(11) NOT NULL,
  `weight` int(11) NOT NULL,
  `gp` int(11) DEFAULT NULL,
  `goals` int(11) DEFAULT NULL,
  `assists` int(11) DEFAULT NULL,
  `shots` int(11) DEFAULT NULL,
  `sog` int(11) DEFAULT NULL,
  `turnovers` int(11) DEFAULT NULL,
  `g_sv` decimal(11,3) DEFAULT NULL,
  `a_to` decimal(11,3) DEFAULT NULL,
  `caused_turnover` int(11) DEFAULT NULL,
  `gb` int(11) DEFAULT NULL,
  `fow` int(11) DEFAULT NULL,
  `fot` int(11) DEFAULT NULL,
  `fow_pct` decimal(11,3) DEFAULT NULL,
  `fogo_gb` int(11) DEFAULT NULL,
  `wing_gb` int(11) DEFAULT NULL,
  `save_pct` decimal(11,3) DEFAULT NULL,
  `clear_turnovers` int(11) DEFAULT NULL,
  `emo_goals` int(11) DEFAULT NULL,
  `emo_assists` int(11) DEFAULT NULL,
  `emo_shots` int(11) DEFAULT NULL,
  `emo_sog` int(11) DEFAULT NULL,
  `emo_turnovers` int(11) DEFAULT NULL,
  `unsettled_goals` int(11) DEFAULT NULL,
  `unsettled_assists` int(11) DEFAULT NULL,
  `unsettled_shots` int(11) DEFAULT NULL,
  `unsettled_sog` int(11) DEFAULT NULL,
  `unsettled_turnovers` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


truncate `ncaa_player_stats`;

insert into `ncaa_player_stats` (year, team_id, team_name, player_id, player_name, jersey_number, class_year, position, town, height, weight)
select roster.year, roster.team_id, roster.team_name, roster.player_id, roster.player_name, roster.jersey_number, roster.class_year, demo.position, concat(demo.town,", ", demo.state) as town, demo.height, demo.weight
from ncaa_rosters roster
left join ncaa_demographics demo on concat(roster.team_name, roster.jersey_number)=demo.code and roster.year=demo.year;


update ncaa_player_stats p
left JOIN
(select sum(b.goals) sumGoals, sum(b.assists) sumAssists, sum(b.shots) sumShots, sum(b.SOG) sumSOG, sum(b.to) sumTurnovers, sum(b.GB) sumGB, sum(b.CT) sumCT, sum(fow) sumfow, sum(fo_taken) sumFOT, sum(saves) sumSaves, sum(goals_allowed) sumgoals_allowed, count(player_id) games, b.player_id, b.year
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
p.save_pct = sumsaves/(sumgoals_allowed + sumSaves),
p.GB = box.sumGB;


update ncaa_player_stats p
left JOIN
(select sum(b.clear_turnover) sumclear_turnover, b.turnover_player, b.team_id, b.year
from ncaa_merged_pbp b
where b.clear_turnover=1
group by b.turnover_player, b.year
) pbp on pbp.turnover_player = p.player_name and pbp.team_id = p.team_id  and pbp.year=p.year
set p.clear_turnovers = pbp.sumclear_turnover;



update ncaa_player_stats p
left JOIN
(select sum(b.goal) sumGoals, sum(b.shot) sumShots, sum(b.saved_shot) sumSaved_shot, b.shot_player, b.team_id, b.year
from ncaa_merged_pbp b
where b.emo=1
group by b.shot_player, b.year
) pbp on pbp.shot_player = p.player_name and pbp.team_id = p.team_id  and pbp.year=p.year
set p.emo_goals = pbp.sumGoals,
p.emo_shots = pbp.sumShots,
p.emo_sog = coalesce(pbp.sumSaved_shot + pbp.sumGoals, pbp.sumSaved_shot, pbp.sumGoals);



update ncaa_player_stats p
left JOIN
(select sum(b.goal) sumGoals, sum(b.shot) sumShots, sum(b.saved_shot) sumSaved_shot, b.shot_player, b.team_id, b.year
from ncaa_merged_pbp b
where b.unsettled=1
group by b.shot_player, b.year
) pbp on pbp.shot_player = p.player_name and pbp.team_id = p.team_id  and pbp.year=p.year
set p.unsettled_goals = pbp.sumGoals,
p.unsettled_shots = pbp.sumShots,
p.unsettled_sog = coalesce(pbp.sumSaved_shot + pbp.sumGoals, pbp.sumSaved_shot, pbp.sumGoals);


update ncaa_player_stats p
left JOIN
(select sum(b.assist) sumAssists, b.assist_player, b.team_id, b.year
from ncaa_merged_pbp b
where b.emo=1
group by b.assist_player, b.year
) pbp on pbp.assist_player = p.player_name and pbp.team_id = p.team_id  and pbp.year=p.year
set p.emo_assists = pbp.sumAssists;

update ncaa_player_stats p
left JOIN
(select sum(b.assist) sumAssists, b.assist_player,  b.team_id
from ncaa_merged_pbp b
where b.unsettled=1
group by b.assist_player, b.year
) pbp on pbp.assist_player = p.player_name and pbp.team_id = p.team_id
set p.unsettled_assists = pbp.sumAssists;


update ncaa_player_stats p
left JOIN
(select sum(b.turnover) sumTurnover, b.turnover_player, b.team_id, b.year
from ncaa_merged_pbp b
where b.emo=1
group by b.turnover_player, b.year
) pbp on pbp.turnover_player = p.player_name and pbp.team_id = p.team_id  and pbp.year=p.year
set p.emo_turnovers = pbp.sumTurnover;

update ncaa_player_stats p
left JOIN
(select sum(b.turnover) sumTurnover, b.turnover_player, b.team_id, b.year
from ncaa_merged_pbp b
where b.unsettled=1
group by b.turnover_player, b.year
) pbp on pbp.turnover_player = p.player_name and pbp.team_id = p.team_id  and pbp.year=p.year
set p.unsettled_turnovers = pbp.sumTurnover;


update ncaa_player_stats p
left JOIN
(select sum(b.fogo_gb) sumFogo, b.fow_player, b.team_id, b.year
from ncaa_merged_pbp b
where b.fogo_gb=1
group by b.fow_player, b.year
) pbp on pbp.fow_player = p.player_name and pbp.team_id = p.team_id  and pbp.year=p.year
set p.fogo_gb = pbp.sumFogo;

update ncaa_player_stats p
left JOIN
(select sum(b.wing_gb) sumwing, b.gb_player, b.team_id, b.year
from ncaa_merged_pbp b
where b.wing_gb=1
group by b.gb_player, b.year
) pbp on pbp.gb_player = p.player_name and pbp.team_id = p.team_id  and pbp.year=p.year
set p.wing_gb = pbp.sumwing;
