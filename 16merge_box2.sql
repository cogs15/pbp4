use `ncaa_lacrosse`;

update ncaa_merged_pbp t1, (select game_id, player_name, team_id, position from ncaa_player_game_stats) t2
set t1.shot_position = t2.position
where t1.game_id=t2.game_id and t1.shot_player = t2.player_name and t1.team_id=t2.team_id and shot=1;

update ncaa_merged_pbp t1, (select game_id, player_name, team_id, position from ncaa_player_game_stats) t2
set t1.assist_position = t2.position
where t1.game_id=t2.game_id and t1.assist_player = t2.player_name and t1.team_id=t2.team_id and assist=1;

update ncaa_merged_pbp t1, (select game_id, player_name, team_id, position from ncaa_player_game_stats) t2
set t1.turnover_position = t2.position
where t1.game_id=t2.game_id and t1.turnover_player = t2.player_name and t1.team_id=t2.team_id and turnover=1;


update ncaa_efficiency t1, (select game_id, team_id, sum(shot) as unsettled_shots from ncaa_merged_pbp where unsettled=1 group by team_id) t2
  set t1.unsettled_pct_shot = t2.unsettled_shots/t1.shots
  where t1.team_id=t2.team_id;

  update ncaa_efficiency t1, (select game_id, team_id, sum(shot) as unsettled_shots from ncaa_merged_pbp where unsettled=1 group by team_id) t2
    set t1.unsettled_pct_shot = t2.unsettled_shots/t1.shots
    where t1.team_id=t2.team_id;

    update ncaa_efficiency t1, (select game_id, opponent_id, sum(shot) as unsettled_shots from ncaa_merged_pbp where unsettled=1 group by opponent_id) t2
      set t1.opp_unsettled_pct_shot = t2.unsettled_shots/t1.shots
      where t1.team_id=t2.opponent_id;


      update ncaa_efficiency t1, (select team_id, sum(saved_shot_dreb) as defensive_rbds, sum(saved_shot_oreb) as offensive_rbds from ncaa_merged_pbp group by team_id) t2
        set t1.offensive_rbd_pct = t2.offensive_rbds/(t2.offensive_rbds + t2.defensive_rbds)
        where t1.team_id = t2.team_id;

        update ncaa_efficiency t1, (select opponent_id, sum(saved_shot_dreb) as defensive_rbds, sum(saved_shot_oreb) as offensive_rbds from ncaa_merged_pbp group by opponent_id) t2
          set t1.defensive_rbd_pct = t2.defensive_rbds/(t2.offensive_rbds + t2.defensive_rbds)
          where t1.team_id = t2.opponent_id;

          update ncaa_efficiency t1, (select team_id, sum(goal) as goals, sum(saved_shot) as saved_shots, sum(shot) as shots from ncaa_merged_pbp where shot=1 and shot_position='a' group by team_id) t2
            set t1.attack_goals = t2.goals,
            t1.attack_saved_shots = t2.saved_shots,
            t1.attack_shots = t2.shots
            where t1.team_id = t2.team_id;

            update ncaa_efficiency t1, (select team_id, sum(assist) as assists from ncaa_merged_pbp where assist=1 and assist_position='a' group by team_id) t2
              set t1.attack_assists = t2.assists
              where t1.team_id = t2.team_id;

              update ncaa_efficiency t1, (select team_id, sum(turnover) as turnovers from ncaa_merged_pbp where turnover=1 and turnover_position='a' and clear_turnover is null group by team_id) t2
                set t1.attack_turnovers = t2.turnovers
                where t1.team_id = t2.team_id;

                update ncaa_efficiency t1, (select opponent_id, sum(goal) as goals, sum(saved_shot) as saved_shots, sum(shot) as shots from ncaa_merged_pbp where shot=1 and shot_position='a' group by opponent_id) t2
                  set t1.opp_attack_goals = t2.goals,
                  t1.opp_attack_saved_shots = t2.saved_shots,
                  t1.opp_attack_shots = t2.shots
                  where t1.team_id = t2.opponent_id;

                  update ncaa_efficiency t1, (select opponent_id, sum(assist) as assists from ncaa_merged_pbp where assist=1 and assist_position='a' group by opponent_id) t2
                    set t1.opp_attack_assists = t2.assists
                  where t1.team_id = t2.opponent_id;

                    update ncaa_efficiency t1, (select opponent_id, sum(turnover) as turnovers from ncaa_merged_pbp where turnover=1 and turnover_position='a' and clear_turnover is null group by opponent_id) t2
                      set t1.opp_attack_turnovers = t2.turnovers
                  where t1.team_id = t2.opponent_id;



                            update ncaa_efficiency t1, (select team_id, sum(goal) as goals, sum(saved_shot) as saved_shots, sum(shot) as shots from ncaa_merged_pbp where shot=1 and shot_position='m' group by team_id) t2
                              set t1.mid_goals = t2.goals,
                              t1.mid_saved_shots = t2.saved_shots,
                              t1.mid_shots = t2.shots
                              where t1.team_id = t2.team_id;

                              update ncaa_efficiency t1, (select team_id, sum(assist) as assists from ncaa_merged_pbp where assist=1 and assist_position='m' group by team_id) t2
                                set t1.mid_assists = t2.assists
                                where t1.team_id = t2.team_id;

                                update ncaa_efficiency t1, (select team_id, sum(turnover) as turnovers from ncaa_merged_pbp where turnover=1 and turnover_position='m' and clear_turnover is null group by team_id) t2
                                  set t1.mid_turnovers = t2.turnovers
                                  where t1.team_id = t2.team_id;

                                  update ncaa_efficiency t1, (select opponent_id, sum(goal) as goals, sum(saved_shot) as saved_shots, sum(shot) as shots from ncaa_merged_pbp where shot=1 and shot_position='m' group by opponent_id) t2
                                    set t1.opp_mid_goals = t2.goals,
                                    t1.opp_mid_saved_shots = t2.saved_shots,
                                    t1.opp_mid_shots = t2.shots
                                    where t1.team_id = t2.opponent_id;

                                    update ncaa_efficiency t1, (select opponent_id, sum(assist) as assists from ncaa_merged_pbp where assist=1 and assist_position='m' group by opponent_id) t2
                                      set t1.opp_mid_assists = t2.assists
                                    where t1.team_id = t2.opponent_id;

                                      update ncaa_efficiency t1, (select opponent_id, sum(turnover) as turnovers from ncaa_merged_pbp where turnover=1 and turnover_position='m' and clear_turnover is null group by opponent_id) t2
                                        set t1.opp_mid_turnovers = t2.turnovers
                                    where t1.team_id = t2.opponent_id;

update ncaa_efficiency
  set attack_pt_pct = (attack_goals + attack_assists)/(goals+assists),
 mid_pt_pct = (mid_goals + mid_assists)/(goals+assists),
opp_attack_pt_pct = (opp_attack_goals + opp_attack_assists)/(opp_goals+opp_assists),
opp_mid_pt_pct = (opp_mid_goals + opp_mid_assists)/(opp_goals+opp_assists),
attack_a_to = attack_assists/attack_turnovers,
mid_a_to = mid_assists/mid_turnovers,
opp_attack_a_to = opp_attack_assists/opp_attack_turnovers,
opp_mid_a_to = opp_mid_assists/opp_mid_turnovers,
attack_g_sv = attack_goals/attack_saved_shots,
mid_g_sv = mid_goals/mid_saved_shots,
opp_attack_g_sv = opp_attack_goals/opp_attack_saved_shots,
opp_mid_g_sv = opp_mid_goals/opp_mid_saved_shots;
