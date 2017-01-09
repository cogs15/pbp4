
#!/usr/bin/ruby

require 'watir-webdriver'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'os'

#Check Computer OS
if OS.windows? == true
  User_Name = ENV['USERNAME'] #Windows
else
  User_Name = ENV['USER'] #OSX
end

#teams = Array.new
#CSV.foreach("sites_test2.csv") do |row|
#	teams << row
#end

browser = Watir::Browser.new

#Team = [] + teams.flatten

#	Team.each do |team|

		game_url = "http://www.denverpioneers.com/sports/m-lacros/mtt/denv-m-lacros-mtt.html"
		browser.goto game_url



    sleep 4
    open("page.html","w"){|f| f.puts browser.html}
    doc = Nokogiri::HTML(open("page.html"))
#    doc.xpath("//*[@id='sortable_roster']/tbody/tr").each do |row|


#//*[@id="sortable_roster"]/thead/tr/th[7]/a

#<a href="#" class="fdTableSortTrigger" title="Sort by “Height”">Height</a>



 doc.xpath("//*[@id='sortable_roster']/tbody/tr").each do |row|


row.xpath("td").each do |td|
    player_details = td.text.strip

test << player_details

puts test

		          #  compile_data = [team, followers]
		          #  stats << compile_data
end
end
