
CREATE TABLE `ncaa_box_audit` (
 `game_id` int(11) DEFAULT NULL,
 `section_id` int(11) DEFAULT NULL,
 `player_id` int(11) DEFAULT NULL,
 `player_name` varchar(255) DEFAULT NULL,
 `player_url` text,
 `position` varchar(255) DEFAULT NULL,
 `goals` int(11) DEFAULT NULL,
 `assists` int(11) DEFAULT NULL,
 `points` int(11) DEFAULT NULL,
 `shots` int(11) DEFAULT NULL,
 `sog` int(11) DEFAULT NULL,
 `emo_g` int(11) DEFAULT NULL,
 `man_down_g` int(11) DEFAULT NULL,
 `gb` int(11) DEFAULT NULL,
 `turnovers` int(11) DEFAULT NULL,
 `ct` int(11) DEFAULT NULL,
 `fow` int(11) DEFAULT NULL,
 `fo_taken` int(11) DEFAULT NULL,
 `pen` varchar(11) DEFAULT NULL,
 `pen_time` varchar(255) DEFAULT NULL,
 `g_min` varchar(255) DEFAULT NULL,
 `goals_allowed` int(11) DEFAULT NULL,
 `saves` int(11) DEFAULT NULL,
 `W` int(11) DEFAULT NULL,
 `L` int(11) DEFAULT NULL,
 `T` int(11) DEFAULT NULL,
 `rc` varchar(11) DEFAULT NULL,
 `yc` varchar(11) DEFAULT NULL,
 `clears_att` int(11) DEFAULT NULL,
 `clears_suc` int(11) DEFAULT NULL,
 `clear_pct` decimal(11,3) DEFAULT NULL,
 `year` int(11) DEFAULT NULL,
 `game_date` varchar(255) DEFAULT NULL,
 UNIQUE KEY `game_id` (`game_id`,`section_id`,`player_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


insert into ncaa_box_audit (game_id, section_id, year, game_date)
select distinct t1.game_id, t2.section_id, t1.year, t1.game_date from ncaa_schedules t1
left join ncaa_periods t2 on t1.game_id=t2.game_id
where t1.game_id not in (select distinct t3.game_id from ncaa_box_scores t3) and t2.section_id=0;

update ncaa_box_audit
set player_name='Totals'

insert into ncaa_box_audit (game_id, section_id, year, game_date)
select distinct t1.game_id, t2.section_id, t1.year, t1.game_date from ncaa_schedules t1
left join ncaa_periods t2 on t1.game_id=t2.game_id
where t1.game_id not in (select distinct t3.game_id from ncaa_box_scores t3) and t2.section_id=1;

update ncaa_box_audit
set player_name='Totals';


update ncaa_box_audit t1, (select game_id, section_id, sum(goal) as goals, sum(assist) as assists, sum(shot) as shots, sum(clear_good) as clears_suc, (coalesce(sum(goal),0) + coalesce(sum(assist),0)) as points, (coalesce(sum(goal),0) + coalesce(sum(saved_shot),0)) as sog, sum(turnover) as turnovers, sum(fow) as fow, sum(penalty) as pen, (sum(clear_good) + coalesce(sum(clear_fail),0)) as clears_att, sum(groundball) as gb from ncaa_merged_pbp group by game_id, section_id) t2
set t1.clears_suc= t2.clears_suc,
t1.clears_att=t2.clears_att,
t1.goals=t2.goals,
t1.assists=t2.assists,
t1.points=t2.points,
t1.shots=t2.shots,
t1.sog=t2.sog,
t1.turnovers=t2.turnovers,
t1.fow=t2.fow,
t1.pen=t2.pen,
t1.gb=t2.gb
where t1.game_id=t2.game_id and t1.section_id=t2.section_id;

update ncaa_box_audit t1, (select game_id, section_id, sum(caused_turnover) as ct, sum(fow) as fol, sum(goal) as goals_allowed, sum(saved_shot) as saves from ncaa_merged_pbp group by game_id, section_id) t2
set t1.ct=t2.ct,
t1.fo_taken = coalesce(t1.fow,0) + coalesce(t2.fol,0),
t1.goals_allowed=t2.goals_allowed,
t1.saves=t2.saves
where t1.game_id=t2.game_id and t1.section_id=(1-t2.section_id);

update ncaa_box_scores t1, (select game_id, section_id, sum(clear_good) as clears_suc, (sum(clear_good) + coalesce(sum(clear_fail),0)) as clears_att from ncaa_merged_pbp group by game_id, section_id) t2
set t1.clears_suc= t2.clears_suc,
t1.clears_att=t2.clears_att
where t1.game_id=t2.game_id and t1.section_id=t2.section_id and t1.player_name='Totals' and t1.clears_att is null;


update ncaa_box_scores t1, (select game_id, section_id, saves from ncaa_box_scores where player_name='totals') t2
set t1.sog= t2.saves + t1.goals
where t1.game_id=t2.game_id and t1.section_id=1-t2.section_id and t1.player_name='Totals' and t1.sog=0;
