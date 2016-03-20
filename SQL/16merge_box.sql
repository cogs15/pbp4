drop table `16ncaa_game_stats`;

create table if not exists `16ncaa_game_stats` (
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
        `assists` INT(11) NOT NULL,
              `opp_assists` INT(11) NOT NULL,
              `turnovers` INT(11) NOT NULL,
                    `opp_turnovers` INT(11) NOT NULL,
          `possessions` INT(11) NOT NULL,
      `opp_possessions` Int(11) NOT NULL,
        `game_efficiency` DEC(11,3) NOT NULL,
        `opp_game_efficiency` DEC(11,3) NOT NULL,
        `poss_pct` DEC(11,3) NOT NULL,
            `opp_o_eff` DEC(11,3) NOT NULL,
            `opp_d_eff` DEC(11,3) NOT NULL,
            `opp_avg_poss_pct` DEC(11,3) NOT NULL,
            `clears_suc` INT(11) NOT NULL,
            `opp_clears_suc` INT(11) NOT NULL,
            `clears_att` INT(11) NOT NULL,
            `opp_clears_att` INT(11) NOT NULL,
            `shots` INT(11) NOT NULL,
        `opp_shots` Int(11) NOT NULL,
        `groundballs` INT(11) NOT NULL,
    `opp_groundballs` Int(11) NOT NULL,
    `fow` INT(11) NOT NULL,
`fol` Int(11) NOT NULL

);

truncate `16ncaa_game_stats`;

insert into `16ncaa_game_stats` (year_id, year, game_date, division_id, team_id, opponent_id, game_id, goals,  opp_goals, assists, opp_assists, turnovers, opp_turnovers, possessions, opp_possessions, clears_suc, opp_clears_suc, clears_att, opp_clears_att, shots, opp_shots, groundballs, opp_groundballs, fow, fol)
select sched.year_id, sched.year, sched.game_date, teams.division_id, periods.team_id,
periods2.team_id as opponent_id,
box.game_id, box.goals, box2.goals as opp_goals,  box.assists, box2.assists as opp_assists, box.to as turnovers, box2.to as opp_turnovers, (box.goals + box2.clears_att + 2) as possessions, (box2.goals + box.clears_att + 2) as opp_possessions, box.clears_suc, box2.clears_suc as opp_clears_suc,  box.clears_att, box2.clears_att as opp_clears_att,box.shots as shots, box2.shots as opp_shots, box.gb as groundballs, box2.gb as opp_groundballs, box.fow, box2.fow as fol
from 16ncaa_periods periods
join 16ncaa_periods periods2 on (periods.game_id,1-periods.section_id) = (periods2.game_id, periods2.section_id)
join 16ncaa_box_scores box on (periods.game_id,periods.section_id)=(box.game_id,box.section_id)
join 16ncaa_box_scores box2 on (periods2.game_id,periods2.section_id)=(box2.game_id,box2.section_id)
join 16ncaa_schedule sched on (periods.team_id,periods.game_id)=(sched.team_id,sched.game_id)
join 16ncaa_teams teams on (periods.team_id,sched.year_id)=(teams.team_id,teams.year_id)
where box.player_name= 'totals'
and box2.player_name = 'totals';

update 16ncaa_game_stats p
set game_efficiency = goals/possessions,
opp_game_efficiency = opp_goals/opp_possessions;
update 16ncaa_game_stats p
left JOIN
(select team_name, team_id
from 16ncaa_teams
) c on c.team_id = p.team_id
set p.team_name = c.team_name;

update 16ncaa_game_stats p
left JOIN
(select team_name, team_id
from 16ncaa_teams
) c on c.team_id = p.opponent_id
set p.opponent_name = c.team_name;


update 16ncaa_game_stats
set poss_pct = possessions/(possessions+opp_possessions);

drop table `16ncaa_efficiency`;

create table if not exists `16ncaa_efficiency` (
  `merge_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
  `year_id` INT(11) NOT NULL,
    `year` INT(11) NOT NULL,
    `division_id` INT(11) NOT NULL,
  `team_id` INT(11) NOT NULL,
  `team_name` VARCHAR(255) NOT NULL,
            `pace` DEC(11,3) NOT NULL,
  `adj_o_efficiency` DEC(11,3) NOT NULL,
  `adj_d_efficiency` DEC(11,3) NOT NULL,
            `adj_poss_pct` DEC(11,3) NOT NULL,
              `iso_gb_pct` DEC(11,3) NOT NULL,
              `fow_pct` DEC(11,3) NOT NULL,
              `clear_pct` DEC(11,3) NOT NULL,
              `ride_pct` DEC(11,3) NOT NULL,
              `a_to` DEC(11,3) NOT NULL,
              `opp_a_to` DEC(11,3) NOT NULL,
  `goals` INT(11) NOT NULL,
        `opp_goals` INT(11) NOT NULL,
        `shots` INT(11) NOT NULL,
                `opp_shots` Int(11) NOT NULL,
          `possessions` INT(11) NOT NULL,
      `opp_possessions` Int(11) NOT NULL,
      `efficiency` DEC(11,3) NOT NULL,
      `opp_efficiency` DEC(11,3) NOT NULL,
      `opp_o_eff` DEC(11,3) NOT NULL,
      `opp_d_eff` DEC(11,3) NOT NULL,
      `poss_pct` DEC(11,3) NOT NULL,
      `opp_avg_poss_pct` DEC(11,3) NOT NULL,
      `iso_gb` INT(11) NOT NULL,
  `opp_iso_gb` Int(11) NOT NULL,
  `fow` INT(11) NOT NULL,
`fol` Int(11) NOT NULL
);

truncate `16ncaa_efficiency`;




insert into `16ncaa_efficiency` (year_id, year, division_id, team_id, team_name, clear_pct, ride_pct, a_to, opp_a_to, goals,  opp_goals, shots, opp_shots, possessions, opp_possessions, iso_gb, opp_iso_gb, fow, fol)
select game.year_id, game.year, game.division_id, game.team_id, game.team_name, (sum(clears_suc)/sum(clears_att)) as clear_pct, (1-sum(opp_clears_suc)/sum(opp_clears_att)) as ride_pct, (sum(game.assists)/(sum(game.turnovers)-(sum(game.clears_att)-sum(game.clears_suc)))) as a_to, (sum(game.opp_assists)/(sum(game.opp_turnovers)-(sum(game.opp_clears_att)-sum(game.opp_clears_suc)))) as opp_a_to, sum(game.goals) as goals, sum(game.opp_goals) as opp_goals, sum(shots) as shots, sum(opp_shots) as opp_shots, sum(possessions) as possessions, sum(opp_possessions) as opp_possessions, (sum(groundballs)-sum(fow)) as iso_gb, (sum(opp_groundballs)-sum(fol)) as opp_iso_gb, sum(fow) as fow, sum(fol) as fol
from 16ncaa_game_stats game
group by team_id, year;


update 16ncaa_efficiency
set efficiency = goals/possessions,
opp_efficiency = opp_goals/opp_possessions;

update 16ncaa_efficiency
set poss_pct = possessions/(possessions+opp_possessions);

update 16ncaa_game_stats t1, (select team_id, year, goals, possessions from 16ncaa_efficiency) t2
set t1.opp_o_eff = (t2.goals - t1.opp_goals)/(t2.possessions-t1.opp_possessions)
where t1.opponent_id = t2.team_id and t1.year=t2.year;


update 16ncaa_game_stats t1, (select team_id, year, opp_goals, opp_possessions from 16ncaa_efficiency) t2
set t1.opp_d_eff = (t2.opp_goals - t1.goals)/(t2.opp_possessions-t1.possessions)
where t1.opponent_id = t2.team_id and t1.year=t2.year;

update 16ncaa_game_stats t1, (select team_id, year, goals, possessions from 16ncaa_efficiency) t2
set t1.opp_o_eff = (t2.goals - t1.opp_goals)/(t2.possessions-t1.opp_possessions)
where t1.opponent_id = t2.team_id and t1.year=t2.year;



update 16ncaa_efficiency t1, (select team_id, year, avg(opp_o_eff) as avgo, avg(opp_d_eff) as avgd from 16ncaa_game_stats group by team_id, year) t2
set t1.opp_o_eff = t2.avgo, t1.opp_d_eff = t2.avgd
where t1.team_id = t2.team_id and t1.year = t2.year;


update 16ncaa_efficiency t1, (select team_id, avg(efficiency) as avgo, avg(opp_efficiency) as avgd from 16ncaa_efficiency) t2
set t1.adj_o_efficiency = t1.efficiency * t2.avgo/t1.opp_d_eff,
t1.adj_d_efficiency = t1.opp_efficiency * t2.avgd/t1.opp_o_eff;

update 16ncaa_game_stats t1, (select team_id, year, possessions, opp_possessions from 16ncaa_efficiency) t2
set t1.opp_avg_poss_pct = (t2.possessions-t1.opp_possessions)/((t2.possessions-t1.opp_possessions)+(t2.opp_possessions-t1.possessions))
where t1.opponent_id = t2.team_id and t1.year=t2.year;

update 16ncaa_efficiency t1, (select team_id, year, avg(opp_avg_poss_pct) as avgposs from 16ncaa_game_stats group by team_id, year) t2
set t1.opp_avg_poss_pct = t2.avgposs
where t1.team_id = t2.team_id and t1.year = t2.year;

update 16ncaa_efficiency
  set adj_poss_pct = poss_pct/(0.5)*opp_avg_poss_pct;

  update 16ncaa_efficiency t1, (select team_id, year, avg(possessions) as avgposs, avg(opp_possessions) as avgoppposs from 16ncaa_game_stats group by team_id, year) t2
  set t1.pace = avgposs+avgoppposs
  where t1.team_id = t2.team_id and t1.year = t2.year;

update 16ncaa_efficiency
  set adj_poss_pct = poss_pct/(0.5)*opp_avg_poss_pct;



  update 16ncaa_efficiency
    set fow_pct=fow/(fow+fol);

    update 16ncaa_efficiency
      set iso_gb_pct=iso_gb/(iso_gb+opp_iso_gb);
