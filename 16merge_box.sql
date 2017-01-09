use `ncaa_lacrosse`;

#drop table `ncaa_game_stats`;

create table if not exists `ncaa_game_stats` (
  `merge_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
  `year_id` INT(11) NOT NULL,
    `year` INT(11) NOT NULL,
  `game_date` VARCHAR(255) NOT NULL,
    `division` INT(11) NOT NULL,
  `team_id` INT(11) NOT NULL,
  `team_name` VARCHAR(255) NOT NULL,
  `opponent_id` INT(11) NOT NULL,
  `opponent_name` VARCHAR(255) NOT NULL,
  `game_id` INT(11) NOT NULL,
  `win` INT(11) NOT NULL,
  `loss` INT(11) NOT NULL,
  `goals` INT(11) NOT NULL,
        `opp_goals` INT(11) NOT NULL,
        `assists` INT(11) NOT NULL,
              `opp_assists` INT(11) NOT NULL,
              `turnovers` INT(11) NOT NULL,
                    `opp_turnovers` INT(11) NOT NULL,
          `possessions` INT(11) NOT NULL,
      `opp_possessions` Int(11) NOT NULL,
      `possession_time` DEC(11,3) NOT NULL,
      `opp_possession_time` DEC(11,3) NOT NULL,
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
            `fow_clear` INT(11) NOT NULL,
            `opp_fow_clear` INT(11) NOT NULL,
            `offensive_end_failed_clear` INT(11) NOT NULL,
            `opp_offensive_end_failed_clear` INT(11) NOT NULL,
            `shots` INT(11) NOT NULL,
        `opp_shots` Int(11) NOT NULL,
        `saved_shots` INT(11) NOT NULL,
    `opp_saved_shots` Int(11) NOT NULL,
    `saved_shots_end` INT(11) NOT NULL,
`opp_saved_shots_end` Int(11) NOT NULL,
            `shot_turnovers` INT(11) NOT NULL,
`opp_shot_turnovers` Int(11) NOT NULL,
        `groundballs` INT(11) NOT NULL,
    `opp_groundballs` Int(11) NOT NULL,
    `fow` INT(11) NOT NULL,
`fol` Int(11) NOT NULL

);

truncate `ncaa_game_stats`;

insert into `ncaa_game_stats` (year_id, year, game_date, division, team_id, opponent_id, game_id, goals, opp_goals, assists, opp_assists, turnovers, opp_turnovers, possessions, opp_possessions, clears_suc, opp_clears_suc, clears_att, opp_clears_att, shots, opp_shots, saved_shots, opp_saved_shots, groundballs, opp_groundballs, fow, fol)
select sched.year_id, sched.year, sched.game_date, teams.division, periods.team_id,
periods2.team_id as opponent_id,
box.game_id, box.goals, box2.goals as opp_goals,  box.assists, box2.assists as opp_assists, box.turnovers as turnovers, box2.turnovers as opp_turnovers, (box.goals + box2.clears_att + 2) as possessions, (box2.goals + box.clears_att + 2) as opp_possessions, box.clears_suc, box2.clears_suc as opp_clears_suc,  box.clears_att, box2.clears_att as opp_clears_att,box.shots as shots, box2.shots as opp_shots, (box.sog - box.goals) as saved_shots, (box2.sog - box2.goals) as opp_saved_shots, box.gb as groundballs, box2.gb as opp_groundballs, box.fow, box2.fow as fol
from ncaa_periods periods
join ncaa_periods periods2 on (periods.game_id,1-periods.section_id) = (periods2.game_id, periods2.section_id)
join ncaa_box_scores box on (periods.game_id,periods.section_id)=(box.game_id,box.section_id)
join ncaa_box_scores box2 on (periods2.game_id,periods2.section_id)=(box2.game_id,box2.section_id)
join ncaa_schedules sched on (periods.team_id,periods.game_id)=(sched.team_id,sched.game_id)
join ncaa_teams teams on (periods.team_id,sched.year_id)=(teams.team_id,teams.year_id)
where box.player_name= 'totals'
and box2.player_name = 'totals';

update ncaa_game_stats
set loss=1 where opp_goals>goals;

update ncaa_game_stats
set win=1 where goals>opp_goals;

update ncaa_game_stats t1, (select game_id, sum(fow_clear) as fow_clear, team_id from ncaa_merged_pbp group by team_id, game_id) t2
  set t1.fow_clear = t2.fow_clear
  where t1.game_id = t2.game_id and t1.team_id = t2.team_id;

  update ncaa_game_stats t1, (select game_id, sum(fow_clear) as fow_clear, opponent_id from ncaa_merged_pbp group by opponent_id, game_id) t2
    set t1.opp_fow_clear = t2.fow_clear
    where t1.game_id = t2.game_id and t1.team_id = t2.opponent_id;

    update ncaa_game_stats t1, (select game_id, sum(clear_to_offensive_end) as offensive_end_failed_clear, team_id from ncaa_merged_pbp group by team_id, game_id) t2
      set t1.offensive_end_failed_clear = t2.offensive_end_failed_clear
      where t1.game_id = t2.game_id and t1.team_id = t2.team_id;

      update ncaa_game_stats t1, (select game_id, sum(clear_to_offensive_end) as offensive_end_failed_clear, opponent_id from ncaa_merged_pbp group by opponent_id, game_id) t2
        set t1.opp_offensive_end_failed_clear = t2.offensive_end_failed_clear
        where t1.game_id = t2.game_id and t1.team_id = t2.opponent_id;

        update ncaa_game_stats t1, (select game_id, sum(saved_shot_end) as saved_shots_end, sum(shot_turnover) as shot_turnovers, team_id from ncaa_merged_pbp group by team_id, game_id) t2
          set t1.saved_shots_end = t2.saved_shots_end,
          t1.shot_turnovers = t2.shot_turnovers
          where t1.game_id = t2.game_id and t1.team_id = t2.team_id;

          update ncaa_game_stats t1, (select game_id, sum(saved_shot_end) as saved_shots_end, sum(shot_turnover) as shot_turnovers, opponent_id from ncaa_merged_pbp group by opponent_id, game_id) t2
            set t1.opp_saved_shots_end = t2.saved_shots_end,
            t1.opp_shot_turnovers = t2.shot_turnovers
            where t1.game_id = t2.game_id and t1.team_id = t2.opponent_id;


update ncaa_game_stats
  set possessions = possessions-opp_fow_clear - offensive_end_failed_clear,
  opp_possessions = opp_possessions - fow_clear - opp_offensive_end_failed_clear;

  update ncaa_game_stats
    set possessions = goals + saved_shots + turnovers
    where possessions<=0;

    update ncaa_game_stats
      set opp_possessions = opp_goals + opp_saved_shots + opp_turnovers
      where opp_possessions<=0;


update ncaa_game_stats p
set game_efficiency = goals/possessions,
opp_game_efficiency = opp_goals/opp_possessions;

update ncaa_game_stats p
left JOIN
(select team_name, team_id, year_id
from ncaa_teams
) c on c.team_id = p.team_id and c.year_id = p.year_id
set p.team_name = c.team_name;

update ncaa_game_stats p
left JOIN
(select team_name, team_id, year_id
from ncaa_teams
) c on c.team_id = p.opponent_id and c.year_id = p.year_id
set p.opponent_name = c.team_name;


update ncaa_game_stats
set poss_pct = possessions/(possessions+opp_possessions);

update ncaa_game_stats t1, (select game_id, sum(time_elapsed) as poss_time, penalty, team_id from ncaa_merged_pbp where penalty is null and time_elapsed>=0 and time_elapsed<=3 group by team_id, game_id) t2
  set t1.possession_time = t2.poss_time
  where t1.game_id = t2.game_id and t1.team_id = t2.team_id;


  update ncaa_game_stats t1, (select game_id, sum(time_elapsed) as poss_time, penalty, team_id, opponent_id from ncaa_merged_pbp where penalty is null and time_elapsed>=0 and time_elapsed<=3 group by opponent_id, game_id) t2
    set t1.opp_possession_time = t2.poss_time
    where t1.game_id = t2.game_id and t1.team_id = t2.opponent_id;




#drop table `ncaa_efficiency`;

create table if not exists `ncaa_efficiency` (
  `merge_id` int(11) NOT NULL AUTO_INCREMENT,
  `year_id` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `division` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  `team_name` varchar(255) NOT NULL,
  `pace` decimal(11,3) NOT NULL,
  `adj_o_efficiency` decimal(11,3) NOT NULL,
  `adj_d_efficiency` decimal(11,3) NOT NULL,
  `adj_poss_pct` decimal(11,3) NOT NULL,
  `iso_gb_pct` decimal(11,3) NOT NULL,
  `fow_pct` decimal(11,3) NOT NULL,
  `clear_pct` decimal(11,3) NOT NULL,
  `ride_pct` decimal(11,3) NOT NULL,
  `a_to` decimal(11,3) NOT NULL,
  `opp_a_to` decimal(11,3) NOT NULL,
  `g_sv` decimal(11,3) NOT NULL,
  `opp_g_sv` decimal(11,3) NOT NULL,
  `g_shto` decimal(11,3) NOT NULL,
  `opp_g_shto` decimal(11,3) NOT NULL,
  `attack_a_to` decimal(11,3) DEFAULT NULL,
  `opp_attack_a_to` decimal(11,3) DEFAULT NULL,
  `mid_a_to` decimal(11,3) DEFAULT NULL,
  `opp_mid_a_to` decimal(11,3) DEFAULT NULL,
  `attack_g_sv` decimal(11,3) DEFAULT NULL,
  `opp_attack_g_sv` decimal(11,3) DEFAULT NULL,
  `mid_g_sv` decimal(11,3) DEFAULT NULL,
  `opp_mid_g_sv` decimal(11,3) DEFAULT NULL,
  `unsettled_pct_shot` decimal(11,3) DEFAULT NULL,
  `opp_unsettled_pct_shot` decimal(11,3) DEFAULT NULL,
  `attack_pt_pct` decimal(11,3) NOT NULL,
  `opp_attack_pt_pct` decimal(11,3) NOT NULL,
  `mid_pt_pct` decimal(11,3) NOT NULL,
  `opp_mid_pt_pct` decimal(11,3) NOT NULL,
  `goals` int(11) NOT NULL,
  `opp_goals` int(11) NOT NULL,
  `saved_shots` int(11) NOT NULL,
  `opp_saved_shots` int(11) NOT NULL,
  `saved_shots_end` INT(11) NOT NULL,
`opp_saved_shots_end` Int(11) NOT NULL,
          `shot_turnovers` INT(11) NOT NULL,
`opp_shot_turnovers` Int(11) NOT NULL,
  `assists` int(11) NOT NULL,
  `opp_assists` int(11) NOT NULL,
  `shots` int(11) NOT NULL,
  `opp_shots` int(11) NOT NULL,
  `possessions` int(11) NOT NULL,
  `opp_possessions` int(11) NOT NULL,
  `efficiency` decimal(11,3) NOT NULL,
  `opp_efficiency` decimal(11,3) NOT NULL,
  `opp_o_eff` decimal(11,3) NOT NULL,
  `opp_d_eff` decimal(11,3) NOT NULL,
  `poss_pct` decimal(11,3) NOT NULL,
  `opp_avg_poss_pct` decimal(11,3) NOT NULL,
  `iso_gb` int(11) NOT NULL,
  `opp_iso_gb` int(11) NOT NULL,
  `offensive_rbd_pct` decimal(11,3) DEFAULT NULL,
  `defensive_rbd_pct` decimal(11,3) DEFAULT NULL,
  `fow` int(11) NOT NULL,
  `fol` int(11) NOT NULL,
  `fow_clear` int(11) NOT NULL,
  `opp_fow_clear` int(11) NOT NULL,
  `attack_goals` int(11) DEFAULT NULL,
  `attack_assists` int(11) DEFAULT NULL,
  `attack_saved_shots` int(11) DEFAULT NULL,
  `attack_shots` int(11) DEFAULT NULL,
  `attack_turnovers` int(11) DEFAULT NULL,
  `opp_attack_goals` int(11) DEFAULT NULL,
  `opp_attack_assists` int(11) DEFAULT NULL,
  `opp_attack_saved_shots` int(11) DEFAULT NULL,
  `opp_attack_shots` int(11) DEFAULT NULL,
  `opp_attack_turnovers` int(11) DEFAULT NULL,
  `mid_goals` int(11) DEFAULT NULL,
  `mid_assists` int(11) DEFAULT NULL,
  `mid_saved_shots` int(11) DEFAULT NULL,
  `mid_shots` int(11) DEFAULT NULL,
  `mid_turnovers` int(11) DEFAULT NULL,
  `opp_mid_goals` int(11) DEFAULT NULL,
  `opp_mid_assists` int(11) DEFAULT NULL,
  `opp_mid_saved_shots` int(11) DEFAULT NULL,
  `opp_mid_shots` int(11) DEFAULT NULL,
  `opp_mid_turnovers` int(11) DEFAULT NULL,
  PRIMARY KEY (`merge_id`)
);

truncate `ncaa_efficiency`;




insert into `ncaa_efficiency` (year_id, year, division, team_id, team_name, clear_pct, ride_pct, a_to, opp_a_to, goals, opp_goals, saved_shots, opp_saved_shots, saved_shots_end, opp_saved_shots_end, shot_turnovers, opp_shot_turnovers, assists, opp_assists, shots, opp_shots, possessions, opp_possessions, iso_gb, opp_iso_gb, fow, fol)
select game.year_id, game.year, game.division, game.team_id, game.team_name, (sum(game.clears_suc)/sum(game.clears_att)) as clear_pct, (1-sum(game.opp_clears_suc)/sum(game.opp_clears_att)) as ride_pct,
(sum(game.assists)/(sum(game.turnovers)-(sum(game.clears_att)-sum(game.clears_suc)))) as a_to, (sum(game.opp_assists)/(sum(game.opp_turnovers)-(sum(game.opp_clears_att)-sum(game.opp_clears_suc)))) as opp_a_to, sum(game.goals) as goals, sum(game.opp_goals) as opp_goals, sum(game.saved_shots) as saved_shots, sum(game.opp_saved_shots) as opp_saved_shots, sum(game.saved_shots_end) as saved_shots_end, sum(game.opp_saved_shots_end) as opp_saved_shots_end, sum(game.shot_turnovers) as shot_turnovers, sum(game.opp_shot_turnovers) as opp_shot_turnovers, sum(game.assists) as assists, sum(game.opp_assists) as opp_assists,  sum(shots) as shots,
sum(opp_shots) as opp_shots, sum(possessions) as possessions, sum(opp_possessions) as opp_possessions, (sum(groundballs)-sum(fow)) as iso_gb, (sum(opp_groundballs)-sum(fol)) as opp_iso_gb, sum(fow) as fow, sum(fol) as fol
from ncaa_game_stats game
group by team_id, year;


update ncaa_efficiency
set efficiency = goals/possessions,
opp_efficiency = opp_goals/opp_possessions;

update ncaa_efficiency
set poss_pct = possessions/(possessions+opp_possessions);

update ncaa_game_stats t1, (select team_id, year, goals, possessions, division from ncaa_efficiency) t2
set t1.opp_o_eff = (t2.goals - t1.opp_goals)/(t2.possessions-t1.opp_possessions)
where t1.opponent_id = t2.team_id and t1.year=t2.year and t1.division = t2.division;


update ncaa_game_stats t1, (select team_id, year, opp_goals, opp_possessions, division from ncaa_efficiency) t2
set t1.opp_d_eff = (t2.opp_goals - t1.goals)/(t2.opp_possessions-t1.possessions)
where t1.opponent_id = t2.team_id and t1.year=t2.year and t1.division = t2.division;

update ncaa_game_stats t1, (select team_id, year, goals, possessions, division from ncaa_efficiency) t2
set t1.opp_o_eff = (t2.goals - t1.opp_goals)/(t2.possessions-t1.opp_possessions)
where t1.opponent_id = t2.team_id and t1.year=t2.year  and t1.division = t2.division;



update ncaa_efficiency t1, (select team_id, year, avg(opp_o_eff) as avgo, avg(opp_d_eff) as avgd, division from ncaa_game_stats group by team_id, year) t2
set t1.opp_o_eff = t2.avgo, t1.opp_d_eff = t2.avgd
where t1.team_id = t2.team_id and t1.year = t2.year  and t1.division = t2.division;


update ncaa_efficiency t1, (select team_id, avg(efficiency) as avgo, avg(opp_efficiency) as avgd, division from ncaa_efficiency) t2
set t1.adj_o_efficiency = t1.efficiency * avgd/t1.opp_d_eff,
t1.adj_d_efficiency = t1.opp_efficiency * avgo/t1.opp_o_eff;

update ncaa_game_stats t1, (select team_id, year, possessions, opp_possessions from ncaa_efficiency) t2
set t1.opp_avg_poss_pct = (t2.possessions-t1.opp_possessions)/((t2.possessions-t1.opp_possessions)+(t2.opp_possessions-t1.possessions))
where t1.opponent_id = t2.team_id and t1.year=t2.year;

update ncaa_efficiency t1, (select team_id, year, avg(opp_avg_poss_pct) as avgposs, division from ncaa_game_stats group by team_id, year) t2
set t1.opp_avg_poss_pct = t2.avgposs
where t1.team_id = t2.team_id and t1.year = t2.year   and t1.division = t2.division;

update ncaa_efficiency
  set adj_poss_pct = poss_pct/(0.5)*opp_avg_poss_pct;

  update ncaa_efficiency t1, (select team_id, year, avg(possessions) as avgposs, avg(opp_possessions) as avgoppposs from ncaa_game_stats group by team_id, year) t2
  set t1.pace = avgposs+avgoppposs
  where t1.team_id = t2.team_id and t1.year = t2.year;

update ncaa_efficiency
  set adj_poss_pct = poss_pct/(0.5)*opp_avg_poss_pct;



  update ncaa_efficiency
    set fow_pct=fow/(fow+fol);

    update ncaa_efficiency
      set iso_gb_pct=iso_gb/(iso_gb+opp_iso_gb);

      update ncaa_efficiency
        set g_sv = goals/saved_shots,
        opp_g_sv = opp_goals/opp_saved_shots;

        update ncaa_efficiency
          set g_shto = goals/shot_turnovers,
          opp_g_shto = opp_goals/opp_shot_turnovers;
