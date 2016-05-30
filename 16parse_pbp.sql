use `ncaa_lacrosse`;

update ncaa_merged_pbp
    set
fow = 1,
fow_player = split_part(split_part(split_part(replace(play_text,'Faceoff ',''),'[',1),' won by ',1),' vs ',1),
fol_player = split_part(split_part(split_part(replace(play_text,'Faceoff ',''),'[',1),' won by ',1),' vs ',2)
where section_id=0 and play_text like 'Faceoff %';


update ncaa_merged_pbp
    set
fow = 1,
fow_player = split_part(split_part(split_part(replace(play_text,'Faceoff ',''),'[',1),' won by ',1),' vs ',2),
fol_player = split_part(split_part(split_part(replace(play_text,'Faceoff ',''),'[',1),' won by ',1),' vs ',1)
where section_id=1 and play_text like 'Faceoff %';

update ncaa_merged_pbp
    set
    gb_player= replace(split_part(split_part(play_text,'Ground ball ',2),'pickup by ',2),'.',''),
    gb_player = substring(gb_player, locate(' ', gb_player)+1)
    where play_text like 'Faceoff %' and play_text like '% ground ball pickup %';


    update ncaa_merged_pbp
    set
    fo_violation = 1
        where play_text like 'Faceoff %' and play_text like '% violation%';

    update ncaa_merged_pbp
    set
    fogo_gb= 1
        where play_text like 'Faceoff %' and fow_player = gb_player;

        update ncaa_merged_pbp
          set
          wing_gb= 1
              where fow=1 and gb_player is not null and gb_player<>fow_player and fo_violation is null;



        update ncaa_merged_pbp
        set
        shot= 1,
         shot_player= replace(split_part(play_text,'Shot by ',2),'.',''),
        shot_player = substring(shot_player, locate(' ', shot_player)+1)
            where play_text like 'Shot by %' and play_text not like '%Save %';

            update ncaa_merged_pbp
            set
            shot= 1,
             shot_player= replace(replace(replace(replace(replace(replace(replace(replace(split_part(play_text,'Shot by ',2),'.',''),' HIT POST',''),' WIDE',''),' HIGH',''),' BLOCKED',''),' HIT CROSSBAR',''),' LEFT',''),' RIGHT',''),
            shot_player = substring(shot_player, locate(' ', shot_player)+1)
                where play_text like 'Shot by %' and play_text not like '%Save %';





    update ncaa_merged_pbp
    set
    shot= 1,
    saved_shot=1,
     shot_player= split_part(split_part(play_text,'Shot by ',2),', SAVE',1),
    shot_player = substring(shot_player, locate(' ', shot_player)+1)
        where play_text like 'Shot by %' and play_text like '%Save %';

    update ncaa_merged_pbp
    set
    shot= 1,
    goal=1,
     shot_player= replace(split_part(play_text,'GOAL by ',2),'.',''),
     shot_player = substring(shot_player, locate(' ', shot_player)+1)
        where play_text like 'Goal by %' and play_text not like '% (%';

    update ncaa_merged_pbp
    set
    shot= 1,
    goal=1,
     shot_player= split_part(replace(split_part(play_text,'GOAL by ',2),'.',''),' (',1),
     shot_player = substring(shot_player, locate(' ', shot_player)+1)
        where play_text like 'Goal by %' and play_text like '% (%';


    update ncaa_merged_pbp
    set
    shot= 1,
    goal=1,
     shot_player= split_part(replace(split_part(play_text,'GOAL by ',2),'.',''),', goal number',1),
     shot_player = substring(shot_player, locate(' ', shot_player)+1)
        where play_text like 'Goal by %' and play_text like '%, goal number%' and play_text not like '%Assist %';

    update ncaa_merged_pbp
    set
    assist= 1,
     assist_player= split_part(replace(split_part(play_text,'Assist by ',2),'.',''),', goal number',1)
        where play_text like 'Goal by %' and play_text like '%, goal number%' and play_text like '%Assist %';

        update ncaa_merged_pbp
        set
        shot= 1,
        goal=1,
     shot_player= split_part(replace(split_part(play_text,'GOAL by ',2),'.',''),' (',1),
         shot_player = substring(shot_player, locate(' ', shot_player)+1)
            where play_text like 'Goal by %' and play_text like '%, goal number%' and play_text like '% (%';



    update ncaa_merged_pbp
    set
    assist= 1,
     assist_player= replace(split_part(play_text,'Assist by ',2),'.','')
        where play_text like 'Goal by %' and play_text not like '%, goal number%' and play_text like '%Assist %';

   update ncaa_merged_pbp
    set
    shot= 1,
    goal=1,
     shot_player= split_part(replace(split_part(play_text,'GOAL by ',2),'.',''),', Assist',1),
     shot_player = substring(shot_player, locate(' ', shot_player)+1)
        where play_text like 'Goal by %' and play_text not like '%, goal number%' and play_text like '%Assist %';

   update ncaa_merged_pbp
    set
    shot= 1,
    goal=1,
     shot_player= split_part(replace(split_part(play_text,'GOAL by ',2),'.',''),', Assist',1),
     shot_player = substring(shot_player, locate(' ', shot_player)+1)
        where play_text like 'Goal by %' and play_text like '%, goal number%' and play_text like '%Assist %';


        update ncaa_merged_pbp
         set
         shot= 1,
         goal=1,
          shot_player= split_part(replace(split_part(play_text,'GOAL by ',2),'.',''),' (',1),
          shot_player = substring(shot_player, locate(' ', shot_player)+1)
             where play_text like 'Goal by %' and play_text not like '%, goal number%' and play_text like '%Assist %' and play_text like '% (%';




   update ncaa_merged_pbp
    set
    shot= 1,
    goal=1,
     shot_player= split_part(replace(split_part(play_text,'GOAL by ',2),'.',''),' (',1),
     shot_player = substring(shot_player, locate(' ', shot_player)+1)
        where play_text like 'Goal by %' and play_text like '%, goal number%' and play_text like '%Assist %' and play_text like '% (%';

          update ncaa_merged_pbp
          set
          turnover= 1,
          turnover_player= replace(split_part(play_text,'Turnover by ',2),'.',''),
          turnover_player = substring(turnover_player, locate(' ', turnover_player)+1)
           where play_text like 'Turnover by%' and play_text not like '%caused%';

           update ncaa_merged_pbp
           set
           turnover= 1,
           turnover_player= split_part(replace(split_part(play_text,'Turnover by ',2),'.',''),' (',1),
           turnover_player = substring(turnover_player, locate(' ', turnover_player)+1)
            where play_text like 'Turnover by%' and play_text like '%caused%';


            update ncaa_merged_pbp
            set
            shot_player =  replace(replace(shot_player, ', ', ','),',',', '),
            assist_player =  replace(replace(assist_player, ', ', ','),',',', '),
            turnover_player =  replace(replace(turnover_player, ', ', ','),',',', '),
            fow_player = replace(replace(fow_player, ', ', ','),',',', '),
            fol_player = replace(replace(fol_player, ', ', ','),',',', '),
            gb_player = replace(replace(gb_player, ', ', ','),',',', ');

            update ncaa_merged_pbp
            set
            shot_player =  concat(split_part(shot_player,' ',2), ", ",split_part(shot_player, ' ',1))
            where shot_player not like '%,%';

            update ncaa_merged_pbp
            set
            assist_player =  concat(split_part(assist_player,' ',2), ", ",split_part(assist_player, ' ',1))
            where assist_player not like '%,%';

            update ncaa_merged_pbp
            set
            turnover_player =  concat(split_part(turnover_player,' ',2), ", ",split_part(turnover_player, ' ',1))
            where turnover_player not like '%,%';

            update ncaa_merged_pbp
            set
            fow_player =  concat(split_part(fow_player,' ',2), ", ",split_part(fow_player, ' ',1))
            where fow_player not like '%,%';

            update ncaa_merged_pbp
            set
            fol_player =  concat(split_part(fol_player,' ',2), ", ",split_part(fol_player, ' ',1))
            where fol_player not like '%,%';

            update ncaa_merged_pbp
            set
            gb_player =  concat(split_part(gb_player,' ',2), ", ",split_part(gb_player, ' ',1))
            where gb_player not like '%,%';


     update ncaa_merged_pbp
 set adj_time= (split_part(time,':',1) + split_part(time,':',2)/60);


 update ncaa_merged_pbp t1, (select game_id, event_id, adj_time, play_text from ncaa_merged_pbp) t2
 set t1.adj_time=t2.adj_time
 where t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and t1.time is null;

 update ncaa_merged_pbp t1, (select game_id, event_id, adj_time, play_text from ncaa_merged_pbp) t2
 set t1.adj_time=t2.adj_time
 where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t1.time is null and t2.play_text like 'Clear%' and t2.play_text like '%failed%';




   update ncaa_merged_pbp t1, (select game_id, event_id, play_text, opponent_id from ncaa_merged_pbp) t2
  set t1.saved_shot_end=1
  where t1.saved_shot=1 and t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and t2.play_text not like '%penalty%' and t1.team_id = t2.opponent_id;


  update ncaa_merged_pbp
   set
   shot_off= 1
       where shot=1 and saved_shot is null and goal is null;

       update ncaa_merged_pbp t1, (select game_id, event_id, play_text, opponent_id from ncaa_merged_pbp) t2
      set t1.shot_off_end=1
      where t1.shot_off=1 and t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and t2.play_text not like '%penalty%' and t1.team_id = t2.opponent_id and t2.play_text like 'ground%';

      update ncaa_merged_pbp t1, (select game_id, event_id, play_text, opponent_id from ncaa_merged_pbp) t2
     set t1.shot_off_end=1
     where t1.shot_off=1 and t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and t2.play_text not like '%penalty%' and t1.team_id = t2.opponent_id and t2.play_text like 'clear%';

update ncaa_merged_pbp
  set shot_turnover=1 where shot_off_end=1 or saved_shot_end=1;


  update ncaa_merged_pbp
  set poss_start=1
  where play_text like  'clear%' and play_text like '%good%';


   update ncaa_merged_pbp
  set poss_start=1
   where play_text like  'Faceoff %';

   update ncaa_merged_pbp t1, (select game_id, event_id, play_text, opponent_id from ncaa_merged_pbp) t2
  set t1.saved_shot_end=1
  where t1.poss_end=1 and t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and t2.play_text not like 'Faceoff%' and t2.play_text not like  'clear%' and t2.play_text not like '%good%';


 update ncaa_merged_pbp
 set poss_end=1
 where goal=1 or turnover=1 or saved_shot_end=1;

update ncaa_merged_pbp t1, (select poss_end, event_id, game_id from ncaa_merged_pbp) t2
  set t1.poss_start=1
  where t2.poss_end=1 and t1.game_id=t2.game_id and t1.event_id=t2.event_id+1;

  update ncaa_merged_pbp
  set poss_time=0
 where poss_start=1;


  update ncaa_merged_pbp t1, (select event_id, game_id, poss_end from ncaa_merged_pbp) t2
  set t1.poss_time= 0
  where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t2.poss_end=1;

  update ncaa_merged_pbp
  set game_time = period_id * 15 + 15 - adj_time;



  update ncaa_merged_pbp
  set poss_time=0;

  update ncaa_merged_pbp
  set poss_start=0
  where poss_start is null;




  update ncaa_merged_pbp t1, (select game_id, event_id, team_id, poss_time, poss_start, poss_end, game_time from ncaa_merged_pbp) t2
set t1.time_elapsed = (t1.game_time - t2.game_time)
where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1;

UPDATE
    ncaa_merged_pbp AS p
  JOIN
    ( SELECT
          p1.event_id, p1.game_id
        , count(*) AS cnt
      FROM
          ncaa_merged_pbp AS p1
        JOIN
          ncaa_merged_pbp AS p2
            ON p2.event_id <= p1.event_id
            and p1.game_id = p2.game_id
            and p2.poss_start=1
      GROUP BY
          p1.game_id, p1.event_id

    ) AS g
    ON g.event_id = p.event_id and g.game_id = p.game_id
SET
        p.poss_number = g.cnt;



#  update ncaa_merged_pbp t1, (select game_id, event_id, poss_number, team_id, poss_time, poss_start, poss_end, game_time from ncaa_merged_pbp order by game_id, event_id) t2
#set t1.poss_time= (t1.time_elapsed + t2.poss_time)
#where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t1.poss_number=t2.poss_number;


update ncaa_merged_pbp t1, (select game_id, poss_number, team_id, sum(time_elapsed) as posstime, event_id from ncaa_merged_pbp group by poss_number, game_id) t2
set t1.poss_time= t2.posstime
where t1.game_id=t2.game_id and t1.poss_number=t2.poss_number;


update ncaa_merged_pbp
set total_time_elapsed=0;


update ncaa_merged_pbp t1, (select min(game_time) as mini, poss_number, game_id, event_id from ncaa_merged_pbp group by poss_number, game_id) t2
set t1.total_time_elapsed = t1.game_time-t2.mini
  where t1.poss_number = t2.poss_number and t1.game_id=t2.game_id;




        update ncaa_merged_pbp
       set penalty=1
        where play_text like  '%penalty%';

        update ncaa_merged_pbp
            set
            penalty_length = split_part(split_part(play_text,')',1),'/',2),
            emo_team = opponent_name
        where play_text like  '%penalty%';

        update ncaa_merged_pbp
    set penalty_clock= (split_part(penalty_length,':',1) + split_part(penalty_length,':',2)/60)
            where play_text like  '%penalty%';

            update ncaa_merged_pbp t1, (select game_id, event_id, penalty_clock, emo_team from ncaa_merged_pbp order by event_id) t2
           set t1.penalty_clock= (t2.penalty_clock - t1.time_elapsed),
           t1.emo_team = t2.emo_team
           where  t1.penalty is null and t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t1.goal is null and t2.penalty_clock > 0;

           update ncaa_merged_pbp
           set EMO = 1
            where penalty_clock>0;



            update ncaa_merged_pbp
            set EMO = 1,
          emo_team = team_name
             where play_text like '%MAN-UP%';

             update ncaa_merged_pbp
             set clear_good = 1
              where play_text like 'clear%' and play_text like '%good%';

              update ncaa_merged_pbp
              set clear_fail = 1
               where play_text like 'clear%' and play_text like '%failed%';

               update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id, clear_fail from ncaa_merged_pbp order by event_id) t2
              set t1.clear_turnover=1
              where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t2.clear_fail = 1 and t2.team_id = t1.team_id and t1.turnover=1;

              update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id, clear_fail from ncaa_merged_pbp order by event_id) t2
             set t1.clear_turnover=1
             where t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and t2.clear_fail = 1 and t2.team_id = t1.team_id and t1.turnover=1;

             update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id, opponent_id, clear_turnover, clear_fail from ncaa_merged_pbp order by event_id) t2
            set t1.clear_to_gb=1
            where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t2.clear_fail = 1 and t2.opponent_id = t1.team_id and t1.play_text like 'Ground%';

            update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id, opponent_id, clear_turnover, clear_fail from ncaa_merged_pbp order by event_id) t2
           set t1.clear_to_gb=1
           where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t2.clear_turnover = 1 and t2.opponent_id = t1.team_id and t1.play_text like 'Ground%';



                       update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id, opponent_id, clear_turnover, clear_to_gb, clear_fail from ncaa_merged_pbp order by event_id) t2
                      set t1.clear_after_fail=1
                      where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t2.clear_fail = 1  and t2.opponent_id = t1.team_id and t1.play_text like 'clear%';

                      update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id, opponent_id, clear_turnover, clear_to_gb, clear_fail from ncaa_merged_pbp order by event_id) t2
                     set t1.clear_after_fail=1
                     where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and  t2.clear_turnover=1 and t2.opponent_id = t1.team_id and t1.play_text like 'clear%';

                     update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id, opponent_id, clear_turnover, clear_to_gb, clear_fail from ncaa_merged_pbp order by event_id) t2
                    set t1.clear_after_fail=1
                    where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and  t2.clear_to_gb=1 and t2.team_id = t1.team_id and t1.play_text like 'clear%';

                    update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id, opponent_id, clear_turnover, clear_after_fail from ncaa_merged_pbp order by event_id) t2
                   set t1.clear_to_offensive_end=1
                   where t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and  t1.clear_fail=1 and t2.opponent_id = t1.team_id and t2.clear_after_fail=1;


                   update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id, opponent_id, clear_turnover, clear_after_fail from ncaa_merged_pbp order by event_id) t2
                  set t1.clear_to_offensive_end=1
                  where t1.game_id=t2.game_id and t1.event_id = t2.event_id-2 and  t1.clear_fail=1 and t2.opponent_id = t1.team_id and t2.clear_after_fail=1;

                  update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id, opponent_id, clear_turnover, clear_after_fail from ncaa_merged_pbp order by event_id) t2
                 set t1.clear_to_offensive_end=1
                 where t1.game_id=t2.game_id and t1.event_id = t2.event_id-3 and  t1.clear_fail=1 and t2.opponent_id = t1.team_id and t2.clear_after_fail=1;



             update ncaa_merged_pbp t1, (select game_id, event_id, play_text, clear_good from ncaa_merged_pbp order by event_id) t2
            set t1.unsettled=1
            where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t2.clear_good=1 and t1.time_elapsed < .334;

            update ncaa_merged_pbp t1, (select game_id, event_id, play_text, clear_good from ncaa_merged_pbp order by event_id) t2
           set t1.unsettled_off_clear=1
           where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t2.clear_good=1 and t1.time_elapsed < .334;

           update ncaa_merged_pbp t1, (select game_id, event_id, play_text, fow from ncaa_merged_pbp order by event_id) t2
          set t1.fow_turnover=1
          where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t2.fow and t1.time_elapsed <= .084 and t1.turnover=1;

          update ncaa_merged_pbp t1, (select game_id, event_id, play_text, fow from ncaa_merged_pbp order by event_id) t2
         set t1.unsettled_off_fow=1
         where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t2.fow and t1.time_elapsed < .334 and t1.fow_turnover is null;

          update ncaa_merged_pbp t1, (select game_id, event_id, play_text, fow from ncaa_merged_pbp order by event_id) t2
         set t1.unsettled=1
         where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t2.fow and t1.time_elapsed < .334and t1.fow_turnover is null;




         update ncaa_merged_pbp
         set
         goalie_start = 1,
          goalie= split_part(play_text,' at goalie',1)
             where play_text like '%at goalie%' and game_time=0;

             update ncaa_merged_pbp
             set
             goalie_change = 1,
              goalie= split_part(play_text,' at goalie',1)
                 where play_text like '%at goalie%' and game_time>0;

                 update ncaa_merged_pbp
                 set
                  opp_goalie= replace(split_part(play_text,'SAVE ',2),'.','')
                     where saved_shot=1;

                     update ncaa_merged_pbp
                     set
                    goalie = replace(replace(goalie, ', ', ','),',',', '),
                     opp_goalie = replace(replace(opp_goalie, ', ', ','),',',', ');

                     update ncaa_merged_pbp
                     set
                     goalie = concat(split_part(goalie,' ',2), ", ",split_part(goalie, ' ',1))
                     where goalie not like '%,%';

                     update ncaa_merged_pbp
                     set
                     opp_goalie = concat(split_part(opp_goalie,' ',2), ", ",split_part(opp_goalie, ' ',1))
                     where opp_goalie not like '%,%';


                     update ncaa_merged_pbp t1, (select game_id, event_id, team_id, goalie, opp_goalie, opponent_id from ncaa_merged_pbp order by event_id) t2
                    set t1.goalie=t2.goalie,
                    t1.opp_goalie=t2.opp_goalie
                    where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t1.team_id=t2.team_id and t1.goalie_change is not null;

                    update ncaa_merged_pbp t1, (select game_id, event_id, team_id, goalie, opp_goalie, opponent_id from ncaa_merged_pbp order by event_id) t2
                   set t1.goalie=t2.opp_goalie,
                   t1.opp_goalie=t2.goalie
                   where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t1.team_id=t2.opponent_id and t1.goalie_change is not null;





         update ncaa_merged_pbp t1, (select game_id, event_id, play_text, opponent_id from ncaa_merged_pbp) t2
        set t1.saved_shot_clean=1
        where t1.saved_shot=1 and t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and t2.play_text like 'clear%' and t1.team_id = t2.opponent_id;

        update ncaa_merged_pbp t1, (select game_id, event_id, play_text, opponent_id from ncaa_merged_pbp) t2
       set t1.saved_shot_dreb=1
       where t1.saved_shot=1 and t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and t2.play_text like 'ground%' and t1.team_id = t2.opponent_id;

       update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id from ncaa_merged_pbp) t2
      set t1.saved_shot_oreb=1
      where t1.saved_shot=1 and t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and t2.play_text like 'ground%' and t1.team_id = t2.team_id;


      update ncaa_merged_pbp t1, (select game_id, event_id, play_text, team_id, fow from ncaa_merged_pbp) t2
     set t1.fow_clear=1
     where t1.play_text like 'clear%' and t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t1.team_id = t2.team_id and t2.fow=1;
