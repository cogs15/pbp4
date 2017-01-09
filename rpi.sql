use `ncaa_lacrosse`;

drop table `ncaa_rpi`;


create table if not exists `ncaa_rpi` (
`year_id` INT(11) NOT NULL,
`year` INT(11) NOT NULL,
`division` INT(11) NOT NULL,
`team_id` INT(11) NOT NULL,
`team_name` VARCHAR(255) NOT NULL,
`rank` INT(11) NOT NULL,
`rpi` dec(11,5) NOT NULL,
`top_10_opp_avgrpi` dec(11,2) NOT NULL,
`wins` INT(11) NOT NULL,
`losses` INT(11) NOT NULL,
`win_pct` dec(11,8) NOT NULL,
`owp` dec(11,8) NOT NULL,
`oowp` dec(11,8) NOT NULL,
`T5_wins` INT(11) NOT NULL,
`T5_losses` INT(11) NOT NULL,
`T6_10_wins` INT(11) NOT NULL,
`T6_10_losses` INT(11) NOT NULL,
`T11_20_wins` INT(11) NOT NULL,
`T11_20_losses` INT(11) NOT NULL,
`outside20_wins` INT(11) NOT NULL,
`outside20_losses` INT(11) NOT NULL,
`significant_wins` INT(11) NOT NULL,
`significant_losses` INT(11) NOT NULL,
`avg_rpi_win` dec(11,2) NOT NULL,
`avg_rpi_loss` dec(11,2) NOT NULL,
`sos` dec(11,8) NOT NULL
);

insert into `ncaa_rpi` (year_id, year, division, team_id, team_name, wins, losses)
select game.year_id, game.year, game.division, game.team_id, game.team_name, sum(game.win) as wins, sum(game.loss) as losses
from ncaa_game_stats game
where opponent_name<>""
group by team_id, year;

update ncaa_rpi
set win_pct = wins/(wins+losses);

drop table `ncaa_schedule_rpi`;

create table if not exists `ncaa_schedule_rpi` (
`year_id` INT(11) NOT NULL,
`year` INT(11) NOT NULL,
`game_id` INT(11) NOT NULL,
`game_date` varchar(255) NOT NULL,
`team_division` INT(11) NOT NULL,
`team_id` INT(11) NOT NULL,
`team_name` VARCHAR(255) NOT NULL,
`opponent_division` INT(11) NOT NULL,
`opponent_id` INT(11) NOT NULL,
`opponent_name` VARCHAR(255) NOT NULL,
`win` INT(11) NOT NULL,
`loss` INT(11) NOT NULL,
`OW` INT(11) NOT NULL,
`OL` INT(11) NOT NULL,
`OWP` DEC(11,5) NOT NULL,
`OOWP` DEC(11,5) NOT NULL,
`team_rank` INT(11) NOT NULL,
`team_rpi` DEC(11,7) NOT NULL,
`opponent_rank` INT(11) NOT NULL,
`opponent_rpi` DEC(11,7) NOT NULL
);

insert into `ncaa_schedule_rpi` (year_id, year, game_id, team_division, team_id, team_name, opponent_id, opponent_name, win, loss)
select year_id, year, game_id, game.division as team_division, team_id, team_name, opponent_id, opponent_name, win, loss
from ncaa_game_stats game
where opponent_name<>""
order by game_id, team_id;

delete from ncaa_schedule_rpi where team_name='';

update ncaa_schedule_rpi t1, (select team_id, division, year from ncaa_teams) t2
set t1.opponent_division = t2.division
where t1.opponent_id = t2.team_id and t1.year=t2.year;

update ncaa_schedule_rpi t1, (select year, team_id, opponent_id, sum(win) as OW, sum(loss) as OL from ncaa_schedule_rpi group by year,team_id) t2
set t1.OW = t2.OW,
t1.OL = t2.OL
where t1.opponent_id = t2.team_id and t1.year = t2.year;

update ncaa_schedule_rpi t1, (select year, team_id, opponent_id, sum(win) as OW, sum(loss) as OL from ncaa_schedule_rpi group by year, team_id, opponent_id) t2
set t1.OW = t1.OW - t2.OL,
t1.OL = t1.OL - t2.ow
where t1.team_id = t2.team_id and t1.opponent_id = t2.opponent_id and t1.year = t2.year;

update ncaa_schedule_rpi
set OWP = OW/(OW+OL);

update ncaa_rpi t1, (select year, team_id, avg(owp) as owp from ncaa_schedule_rpi group by year, team_id) t2
set t1.owp = t2.owp
where t1.team_id = t2.team_id and t1.year = t2.year;

update ncaa_schedule_rpi t1, (select year, team_id, opponent_id, avg(owp) as avgowp from ncaa_schedule_rpi group by year, team_id) t2
set t1.oowp = t2.avgowp
where t1.opponent_id = t2.team_id and t1.year = t2.year;

update ncaa_rpi t1, (select year, team_id, opponent_id, avg(oowp) as avgoowp from ncaa_schedule_rpi group by year, team_id) t2
set t1.oowp = t2.avgoowp
where t1.team_id = t2.team_id and t1.year = t2.year;

update ncaa_rpi
set rpi = (.25*win_pct) + (.50*owp) + (.25*oowp);




update ncaa_schedule_rpi
join
(select year, team_id, rpi, @ROWNUM:=case when @group <> year then 1 else @rownum+1 end as rank_calculated,
@group:=year As GroupSet
From ncaa_rpi,
(SELECT @rownum:= 0) s,
  (SELECT @group:= -1) c
  where division=1
   ORDER BY year, rpi desc) r
on r.team_id = ncaa_schedule_rpi.opponent_id and r.year =ncaa_schedule_rpi.year
set ncaa_schedule_rpi.opponent_rank = r.rank_calculated,
ncaa_schedule_rpi.opponent_rpi = r.rpi;


update ncaa_schedule_rpi
join
(select year, team_id, rpi, @ROWNUM:=case when @group <> year then 1 else @rownum+1 end as rank_calculated,
@group:=year As GroupSet
From ncaa_rpi,
(SELECT @rownum:= 0) s,
  (SELECT @group:= -1) c
  where division=2
   ORDER BY year, rpi desc) r
on r.team_id = ncaa_schedule_rpi.opponent_id and r.year =ncaa_schedule_rpi.year
set ncaa_schedule_rpi.opponent_rank = r.rank_calculated,
ncaa_schedule_rpi.opponent_rpi = r.rpi;



update ncaa_schedule_rpi
join
(select year, team_id, rpi, @ROWNUM:=case when @group <> year then 1 else @rownum+1 end as rank_calculated,
@group:=year As GroupSet
From ncaa_rpi,
(SELECT @rownum:= 0) s,
  (SELECT @group:= -1) c
  where division=3
   ORDER BY year, rpi desc) r
on r.team_id = ncaa_schedule_rpi.opponent_id and r.year =ncaa_schedule_rpi.year
set ncaa_schedule_rpi.opponent_rank = r.rank_calculated,
ncaa_schedule_rpi.opponent_rpi = r.rpi;


update ncaa_schedule_rpi
join
(select year, team_id, rpi, @ROWNUM:=case when @group <> year then 1 else @rownum+1 end as rank_calculated,
@group:=year As GroupSet
From ncaa_rpi,
(SELECT @rownum:= 0) s,
  (SELECT @group:= -1) c
  where division=1
   ORDER BY year, rpi desc) r
on r.team_id = ncaa_schedule_rpi.team_id and r.year =ncaa_schedule_rpi.year
set ncaa_schedule_rpi.team_rank = r.rank_calculated,
ncaa_schedule_rpi.team_rpi = r.rpi;



update ncaa_schedule_rpi
join
(select year, team_id, rpi, @ROWNUM:=case when @group <> year then 1 else @rownum+1 end as rank_calculated,
@group:=year As GroupSet
From ncaa_rpi,
(SELECT @rownum:= 0) s,
  (SELECT @group:= -1) c
  where division=2
   ORDER BY year, rpi desc) r
on r.team_id = ncaa_schedule_rpi.team_id and r.year =ncaa_schedule_rpi.year
set ncaa_schedule_rpi.team_rank = r.rank_calculated,
ncaa_schedule_rpi.team_rpi = r.rpi;



update ncaa_schedule_rpi
join
(select year, team_id, rpi, @ROWNUM:=case when @group <> year then 1 else @rownum+1 end as rank_calculated,
@group:=year As GroupSet
From ncaa_rpi,
(SELECT @rownum:= 0) s,
  (SELECT @group:= -1) c
  where division=3
   ORDER BY year, rpi desc) r
on r.team_id = ncaa_schedule_rpi.team_id and r.year =ncaa_schedule_rpi.year
set ncaa_schedule_rpi.team_rank = r.rank_calculated,
ncaa_schedule_rpi.team_rpi = r.rpi;




update ncaa_rpi t1
join
(select year, team_id, rpi, @ROWNUM:=case when @group <> year then 1 else @rownum+1 end as rank_calculated,
@group:=year As GroupSet
From ncaa_rpi,
(SELECT @rownum:= 0) s,
  (SELECT @group:= -1) c
  where division=1
   ORDER BY year, rpi desc) r
on r.team_id = t1.team_id and r.year = t1.year
set t1.rank = r.rank_calculated;


update ncaa_rpi t1
join
(select year, team_id, rpi, @ROWNUM:=case when @group <> year then 1 else @rownum+1 end as rank_calculated,
@group:=year As GroupSet
From ncaa_rpi,
(SELECT @rownum:= 0) s,
  (SELECT @group:= -1) c
  where division=2
   ORDER BY year, rpi desc) r
on r.team_id = t1.team_id and r.year = t1.year
set t1.rank = r.rank_calculated;


update ncaa_rpi t1
join
(select year, team_id, rpi, @ROWNUM:=case when @group <> year then 1 else @rownum+1 end as rank_calculated,
@group:=year As GroupSet
From ncaa_rpi,
(SELECT @rownum:= 0) s,
  (SELECT @group:= -1) c
  where division=3
   ORDER BY year, rpi desc) r
on r.team_id = t1.team_id and r.year = t1.year
set t1.rank = r.rank_calculated;

/*
update ncaa_rpi t1, (select id, year, division, team_name, rpi, rank from (select x.*, if(@pdivision = division, if(@pyear = year, @i:=@i+1, @i:=1) rank, @pyear:=year, @pdivision:=division from ncaa_rpi x , (select @pyear:='', @pdivision:='', @i:=1) vals order by year, division, rpi desc) m) on )
*/

update ncaa_rpi t1, (select year, team_id, sum(win) as OW, sum(loss) as OL from ncaa_schedule_rpi where opponent_rank < 6 group by year, team_id) t2
set t1.T5_wins = t2.OW,
t1.T5_losses = t2.OL
where t1.team_id = t2.team_id and t1.year=t2.year;

update ncaa_rpi t1, (select year, team_id, sum(win) as OW, sum(loss) as OL from ncaa_schedule_rpi where opponent_rank < 11 and opponent_Rank>5 group by year, team_id) t2
set t1.T6_10_wins = t2.OW,
t1.T6_10_losses = t2.OL
where t1.team_id = t2.team_id and t1.year=t2.year;

update ncaa_rpi t1, (select year, team_id, sum(win) as OW, sum(loss) as OL from ncaa_schedule_rpi where opponent_rank < 21 and opponent_Rank>10 group by year, team_id) t2
set t1.T11_20_wins = t2.OW,
t1.T11_20_losses = t2.OL
where t1.team_id = t2.team_id and t1.year=t2.year;

update ncaa_rpi t1, (select year, team_id, sum(win) as OW, sum(loss) as OL from ncaa_schedule_rpi where opponent_rank > 20 group by year, team_id) t2
set t1.outside20_wins = t2.OW,
t1.outside20_losses = t2.OL
where t1.team_id = t2.team_id and t1.year=t2.year;

update ncaa_rpi t1, (SELECT year, team_id, avg(opponent_rank) as averagerpi
FROM
(SELECT year, team_id, opponent_rpi, opponent_rank,
@rpi_rank := IF(@current_team = team_id, @rpi_rank + 1, 1) AS rpi_rank,
@current_team := team_id
FROM ncaa_schedule_rpi
ORDER BY team_id, opponent_rpi DESC
) ranked
WHERE rpi_rank <= 10
group by team_id) t2
set t1.top_10_opp_avgrpi = t2.averagerpi
where t1.team_id = t2.team_id and t1.year=t2.year;

update ncaa_rpi t1, (select year, team_id, avg(opponent_rank) as avgrpi from ncaa_schedule_rpi where win=1 group by year, team_id) t2
set t1.avg_rpi_win = t2.avgrpi
where t1.team_id = t2.team_id and t1.year=t2.year;

update ncaa_rpi t1, (select year, team_id, avg(opponent_rank) as avgrpi from ncaa_schedule_rpi where loss=1 group by year, team_id) t2
set t1.avg_rpi_loss = t2.avgrpi
where t1.team_id = t2.team_id and t1.year=t2.year;

update ncaa_rpi t1, (select year, team_id, sum(win) as significant from ncaa_schedule_rpi where win=1 and team_rank>opponent_rank group by year, team_id) t2
set t1.significant_wins = t2.significant
where t1.team_id = t2.team_id and t1.year=t2.year;

update ncaa_rpi t1, (select year, team_id, sum(loss) as significant from ncaa_schedule_rpi where loss=1 and team_rank<opponent_rank group by year, team_id) t2
set t1.significant_losses = t2.significant
where t1.team_id = t2.team_id and t1.year=t2.year;

update ncaa_rpi t1, (SELECT year, team_id, avg(owp) as sos_1, avg(oowp) as sos_2
FROM
(SELECT year, team_id, opponent_rpi, opponent_rank, owp, oowp,
@rpi_rank := IF(@current_team = team_id, @rpi_rank + 1, 1) AS rpi_rank,
@current_team := team_id
FROM ncaa_schedule_rpi
ORDER BY year, team_id, opponent_rpi DESC
) ranked
WHERE rpi_rank <= 10
group by year, team_id) t2
set t1.sos= ((t2.sos_1*2)+(t2.sos_2))/3
where t1.team_id = t2.team_id and t1.year=t2.year;
