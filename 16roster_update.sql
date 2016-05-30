use `ncaa_lacrosse`;

update ncaa_rosters roster
left JOIN
(select demo.team_name, demo.jersey_number, demo.year, demo.position, concat(demo.town,", ", demo.state) as town, demo.height, demo.weight
from ncaa_demographics demo
) c on concat(c.team_name, c.jersey_number) = concat(roster.team_name, roster.jersey_number)
set roster.position = c.position,
roster.town = c.town,
roster.height = c.height,
roster.weight = c.weight;
