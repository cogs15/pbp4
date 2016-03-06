
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
 where t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and t1.time="";

 update ncaa_merged_pbp t1, (select game_id, event_id, adj_time, play_text from ncaa_merged_pbp) t2
 set t1.adj_time=t2.adj_time
 where t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t1.time="" and t2.play_text like 'Clear%' and t2.play_text like '%failed%';




   update ncaa_merged_pbp t1, (select game_id, event_id, play_text, opponent_id from ncaa_merged_pbp) t2
  set t1.saved_shot_end=1
  where t1.saved_shot=1 and t1.game_id=t2.game_id and t1.event_id = t2.event_id-1 and t2.play_text not like '%penalty%' and t1.team_id = t2.opponent_id;

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

            update ncaa_merged_pbp t1, (select game_id, event_id, play_text, penalty_clock, time_elapsed, emo_team from ncaa_merged_pbp order by event_id) t2
           set t1.penalty_clock= (t2.penalty_clock - t1.time_elapsed),
           t1.emo_team = t2.emo_team
           where  t1.play_text not like '%penalty%' and t1.game_id=t2.game_id and t1.event_id = t2.event_id+1 and t1.play_text not like 'goal %' and t2.penalty_clock > 0;

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
