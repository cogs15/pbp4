drop table `ncaa_game_stats`;

create table if not exists `ncaa_game_stats` (
  `merge_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
  `year_id` INT(11) NOT NULL,
    `year` INT(11) NOT NULL,
  `game_date` VARCHAR(255) NOT NULL,
    `division_id` INT(11) NOT NULL,
  `team_id` INT(11) NOT NULL,
  `team_name` VARCHAR(255) NOT NULL,
  `opponent_id` INT(11) NOT NULL,
  `opponent_name` VARCHAR(255) NOT NULL,
  `game_id` INT(11) NOT NULL,
  `goals` INT(11) NOT NULL,
        `opp_goals` INT(11) NOT NULL,
          `possessions` INT(11) NOT NULL,
      `opp_possessions` Int(11) NOT NULL,
        `game_efficiency` DEC(11,3) NOT NULL,
        `opp_game_efficiency` DEC(11,3) NOT NULL,
    `opp_clears_att` INT(11) NOT NULL,
    `clears_att` INT(11) NOT NULL,
            `opp_o_eff` DEC(11,3) NOT NULL,
            `opp_d_eff` DEC(11,3) NOT NULL,
            `shots` INT(11) NOT NULL,
        `opp_shots` Int(11) NOT NULL
);

truncate `ncaa_game_stats`;

insert into `ncaa_game_stats` (year_id, year, game_date, division_id, team_id, opponent_id, game_id, goals,  opp_goals, possessions, opp_possessions, opp_clears_att, clears_att, shots, opp_shots)
select sched.year_id, sched.year, sched.game_date, teams.division_id, periods.team_id,
periods2.team_id as opponent_id,
box.game_id, box.goals, box2.goals as opp_goals, (box.goals + box2.clears_att + 2) as possessions, (box2.goals + box.clears_att + 2) as opp_possessions, box2.clears_att as opp_clears_att, box.clears_att, box.shots as shots, box2.shots as opp_shots
from ncaa_periods periods
join ncaa_periods periods2 on (periods.game_id,1-periods.section_id) = (periods2.game_id, periods2.section_id)
join ncaa_box_scores box on (periods.game_id,periods.section_id)=(box.game_id,box.section_id)
join ncaa_box_scores box2 on (periods2.game_id,periods2.section_id)=(box2.game_id,box2.section_id)
join ncaa_schedule sched on (periods.team_id,periods.game_id)=(sched.team_id,sched.game_id)
join ncaa_teams teams on (periods.team_id,sched.year_id)=(teams.team_id,teams.year_id)
where box.player_name= 'totals'
and box2.player_name = 'totals';

update ncaa_game_stats p
set game_efficiency = goals/possessions,
opp_game_efficiency = opp_goals/opp_possessions;
update ncaa_game_stats p
left JOIN
(select team_name, team_id
from ncaa_teams
) c on c.team_id = p.team_id
set p.team_name = c.team_name;

update ncaa_game_stats p
left JOIN
(select team_name, team_id
from ncaa_teams
) c on c.team_id = p.opponent_id
set p.opponent_name = c.team_name;




drop table `ncaa_efficiency`;

create table if not exists `ncaa_efficiency` (
  `merge_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
  `year_id` INT(11) NOT NULL,
    `year` INT(11) NOT NULL,
    `division_id` INT(11) NOT NULL,
  `team_id` INT(11) NOT NULL,
  `team_name` VARCHAR(255) NOT NULL,
  `goals` INT(11) NOT NULL,
        `opp_goals` INT(11) NOT NULL,
          `possessions` INT(11) NOT NULL,
      `opp_possessions` Int(11) NOT NULL,
      `efficiency` DEC(11,3) NOT NULL,
      `opp_efficiency` DEC(11,3) NOT NULL,
      `opp_o_eff` DEC(11,3) NOT NULL,
      `opp_d_eff` DEC(11,3) NOT NULL,
      `adj_o_efficiency` DEC(11,3) NOT NULL,
      `adj_d_efficiency` DEC(11,3) NOT NULL
);

truncate `ncaa_efficiency`;

insert into `ncaa_efficiency` (year_id, year, division_id, team_id, team_name, goals,  opp_goals, possessions, opp_possessions)
select game.year_id, game.year, game.division_id, game.team_id, game.team_name, sum(game.goals) as goals, sum(opp_goals) as opp_goals, sum(possessions) as possessions, sum(opp_possessions) as opp_possessions
from ncaa_game_stats game
group by team_id, year;


update ncaa_efficiency
set efficiency = goals/possessions,
opp_efficiency = opp_goals/opp_possessions;

update ncaa_game_stats t1, (select team_id, year, goals, possessions from ncaa_efficiency) t2
set t1.opp_o_eff = (t2.goals - t1.opp_goals)/(t2.possessions-t1.opp_possessions)
where t1.opponent_id = t2.team_id and t1.year=t2.year;


update ncaa_game_stats t1, (select team_id, year, opp_goals, opp_possessions from ncaa_efficiency) t2
set t1.opp_d_eff = (t2.opp_goals - t1.goals)/(t2.opp_possessions-t1.possessions)
where t1.opponent_id = t2.team_id and t1.year=t2.year;

update ncaa_game_stats t1, (select team_id, year, goals, possessions from ncaa_efficiency) t2
set t1.opp_o_eff = (t2.goals - t1.opp_goals)/(t2.possessions-t1.opp_possessions)
where t1.opponent_id = t2.team_id and t1.year=t2.year;


update ncaa_efficiency t1, (select team_id, year, avg(opp_o_eff) as avgo, avg(opp_d_eff) as avgd from ncaa_game_stats group by team_id, year) t2
set t1.opp_o_eff = avgo, t1.opp_d_eff = avgd
where t1.team_id = t2.team_id and t1.year = t2.year;


update ncaa_efficiency t1, (select team_id, avg(efficiency) as avgo, avg(opp_efficiency) as avgd from ncaa_efficiency) t2
set t1.adj_o_efficiency = t1.efficiency * t2.avgo/t1.opp_d_eff,
t1.adj_d_efficiency = t1.opp_efficiency * t2.avgd/t1.opp_o_eff;

delete from ncaa_efficiency where year<2014;
