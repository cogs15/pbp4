create table if not exists `16ncaa_player_stats` (
  `team_id` INT(11) NOT NULL,
  `team_name` VARCHAR(255) NOT NULL,
  `player_id` INT(11) default "",
  `player_name` VARCHAR(255),
  `jersey_number` INT(11) NOT NULL,
  `class_year` VARCHAR(255) NOT NULL,
  `position` VARCHAR(255) NOT NULL,
  `town` VARCHAR(255) NOT NULL,
  `height` INT(11) NOT NULL,
  `weight` INT(11) NOT NULL,
  `goals` INT(11) NOT NULL,
  `assists` INT(11) NOT NULL,
    `shots` INT(11) NOT NULL,
    `turnovers` INT(11) NOT NULL
);

truncate `16ncaa_player_stats`;

insert into `16ncaa_player_stats` (team_id, team_name, player_id, player_name, jersey_number, class_year, position, town, height, weight)
select roster.team_id, roster.team_name, roster.player_id, roster.player_name, roster.jersey_number, roster.class_year, demo.position, concat(demo.town,", ", demo.state) as town, demo.height, demo.weight
from 16ncaa_rosters roster
left join 16ncaa_demographics demo on concat(roster.team_name, roster.jersey_number)=demo.code;


update 16ncaa_player_stats p
left JOIN
(select sum(b.goals) sumGoals, sum(b.assists) sumAssists, sum(b.shots) sumShots, sum(b.SOG) sumSOG, sum(b.to) sumTurnovers, sum(b.GB) sumGB, sum(b.CT) sumCT, sum(fow) sumfow, sum(fo_taken) sumFOT, sum(saves) sumSaves, sum(goals_allowed) sumgoals_allowed, count(player_id) games, b.player_id
from 16ncaa_box_scores b
group by b.player_id
) box on box.player_id = p.player_id
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
p.GB = box.sumGB
