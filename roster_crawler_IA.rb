
#!/usr/bin/ruby

require 'watir-webdriver'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'os'
require './lib/mysql_client.rb'

mysql_client = MySQLClient.new

#Check Computer OS
if OS.windows? == true
  User_Name = ENV['USERNAME'] #Windows
else
  User_Name = ENV['USER'] #OSX
end

team_pages = mysql_client.get_team_pages()

browser = Watir::Browser.new 

team_pages.each_with_index do |page|
      puts "#{page} ..."
      team_url ="#{page}"



		game_url = team_url
		browser.goto game_url


    sleep 10
    open("page.html","w"){|f| f.puts browser.html}
    doc = Nokogiri::HTML(open("page.html"))
    #doc.xpath("//*[@id='sortable_roster']/tbody/tr").each do |row|

i_n = ''
i_num = ''
i_yr = ''
i_pos = ''
i_ht = ''
i_wt = ''
i_home = ''

if browser.table(:id => 'sortable_roster').exists?

#//*[@id="roster-list-table"]/thead/tr/th[3]/div



#First XPath
doc.search("//*[@id='sortable_roster']/thead/tr/th").each do |th|
    if th.text.strip == 'NAME' || th.text.strip == 'Name' || th.text.strip == 'Full Name' || th.text.strip == 'FULL NAME'
        i_n = th.parent.children.index(th)
        puts i_n
    end
    if th.text.strip == '#' || th.text.strip == 'No.'
        i_num = th.parent.children.index(th)
        puts i_num
    end
    if th.text.strip == 'Yr.' || th.text.strip == 'Year' || th.text.strip == 'Class year' || th.text.strip == 'YR.' || th.text.strip == 'Cl.' || th.text.strip == 'Cl' || th.text.strip == 'Yr. '
        i_yr = th.parent.children.index(th)
        puts i_yr
    end
    if th.text.strip == 'Pos.' || th.text.strip == 'Position'
        i_pos = th.parent.children.index(th)
        puts i_pos
    end
    if th.text.strip == 'Ht.' || th.text.strip == 'Height'
        i_ht = th.parent.children.index(th)
        puts i_ht
    end
    if th.text.strip == 'Wt.' || th.text.strip == 'Weight'
        i_wt = th.parent.children.index(th)
        puts i_wt
    end
    if th.text.strip == 'Hometown' || th.text.strip == 'Hometown (High School)' || th.text.strip == 'HOMETOWN / HIGH SCHOOL' || th.text.strip == 'Hometown / High School' || th.text.strip == 'Hometown/High School' || th.text.strip == 'Hometown (Previous School)'
        i_home = th.parent.children.index(th)
        puts i_home
    end
end
t_id = 'sortable_roster'
elsif browser.div(:id => 'mainbody').exists?

#//*[@id='mainbody']//table/tbody/tr[1]/td"



  doc.xpath("//*[@id='mainbody']//thead/tr/td").each do |td|

    if td.text.strip == 'NAME' || td.text.strip == 'Name' || td.text.strip == 'Full name'  || td.text.strip == 'FULL NAME'
        i_n = td.parent.children.index(td) +1
            puts td.text.strip
        puts i_n
    end
    if td.text.strip == '#' || td.text.strip == 'No.'
        i_num = td.parent.children.index(td) +1
            puts td.text.strip
        puts i_num
    end
    if td.text.strip == 'Yr.' || td.text.strip == 'Year' || td.text.strip == 'Class year' || td.text.strip == 'YR.' || td.text.strip == 'Cl.' || td.text == 'Cl' || td.text == 'Yr. '
        i_yr = td.parent.children.index(td) -3
            puts td.text.strip
        puts i_yr
    end
    if td.text.strip == 'Pos.' || td.text.strip == 'Position'
        i_pos = td.parent.children.index(td) -3
    puts td.text.strip
        puts i_pos
    end
    if td.text.strip == 'Ht' || td.text.strip == 'Ht.'
        i_ht = td.parent.children.index(td) -3
            puts td.text.strip
        puts i_ht
    end
    if td.text.strip == 'Wt' || td.text.strip == 'Wt.'
        i_wt = td.parent.children.index(td) -3
            puts td.text.strip
        puts i_wt
      end
    if td.text.strip == 'Hometown' || td.text.strip == 'Hometown (High School)' || td.text.strip == 'HOMETOWN / HIGH SCHOOL' || td.text.strip == 'Hometown / High School' || td.text.strip == 'Hometown/High School' || td.text.strip == 'Hometown (Previous School)'
        i_home = td.parent.children.index(td) -5
    puts td.text.strip
        puts i_home
    end
  end
    t_id = 'mainbody'

#elsif browser.xpath("//*[@id='mainbody']//table/tbody/tr[1]/td").exists?

#  doc.search("//*[@id='mainbody']//table/tbody/tr[1]/td").each do |td|
#      if td.text.include? 'Name'
#          i_n = td.parent.children.index(td)
#          puts i_n
#      end
#      if td.text == '#' || td.text == 'No.'
#          i_num = td.parent.children.index(td)
#          puts i_num
#      end
#      if td.text == 'Yr.' || td.text == 'Year' || td.text == 'Class year' || td.text == 'YR.' || td.text == 'Cl.' || td.text == 'Cl'
#          i_yr = td.parent.children.index(td)
#          puts i_yr
#      end
#      if td.text.include? 'Pos.' || td.text == 'Position'
#          i_pos = td.parent.children.index(td) - 3
#          puts i_pos
#      end
#      if td.text.include? 'Ht.'
#          i_ht = td.parent.children.index(td) - 3
#          puts i_ht
#      end
#      if td.text.include? 'Wt.'
#          i_wt = td.parent.children.index(td) - 3
#          puts i_wt
#        end
#      if td.text == 'Hometown' || td.text == 'Hometown (High School)' || td.text == 'HOMETOWN / HIGH SCHOOL' || td.text == 'Hometown / High School' || td.text == 'Hometown/High School'
#          i_wt = td.parent.children.index(td)
#          puts i_wt
#      end
#  end



#    t_id = 'mainbody'

  elsif browser.table(:id => 'ctl00_cplhMainContent_dgrdRoster').exists?

    doc.search("//*[@id='ctl00_cplhMainContent_dgrdRoster']/thead/tr/th").each do |th|
        if th.text == 'NAME' || th.text == 'Name' || th.text == 'Full name'  || th.text == 'FULL NAME'
            i_n = th.parent.children.index(th)
            puts i_n
        end
        if th.text == '#' || th.text == 'No.'
            i_num = th.parent.children.index(th)
            puts i_num
        end
        if th.text == 'Yr.' || th.text == 'Year' || th.text == 'Class year' || th.text == 'YR.' || th.text == 'Cl.' || th.text == 'Cl' || th.text == 'Yr. '
            i_yr = th.parent.children.index(th)
            puts i_yr
        end
        if th.text == 'Pos.' || th.text == 'Position' || th.text == 'POS.'
            i_pos = th.parent.children.index(th)
            puts i_pos
        end
        if th.text.include? 'Ht.'
            i_ht = th.parent.children.index(th)
            puts i_ht
        end
        if th.text.include? 'Wt.'
            i_wt = th.parent.children.index(th)
            puts i_wt
          end
        if th.text == 'Hometown' || th.text == 'Hometown (High School)' || th.text == 'HOMETOWN / HIGH SCHOOL' || th.text == 'Hometown / High School' || th.text == 'Hometown/High School' || th.text == 'Hometown (Previous School)'
            i_home = th.parent.children.index(th)
            puts i_home
        end
    end
      t_id = 'ctl00_cplhMainContent_dgrdRoster'


#fourth xpath


elsif browser.table(:id => 'main-content').exists?


  doc.search("//*[@id='main-content']//ul/li").each do |li|
      if li.text == 'NAME' || li.text == 'Name'  || li.text == 'FULL NAME'
          i_n = li.parent.children.index(li)
          puts i_n
      end
      if li.text == '#' || li.text == 'No.'
          i_num = li.parent.children.index(li)
          puts i_num
      end
      if li.text == 'Yr.' || li.text == 'Year' || li.text == 'Class year' || li.text == 'YR.' || li.text == 'Cl.' || li.text == 'Cl' || li.text == 'Yr. '
          i_yr = li.parent.children.index(li)
          puts i_yr
      end
      if li.text == 'Pos.' || li.text == 'Position' || li.text == 'POS.'
          i_pos = li.parent.children.index(li)
          puts i_pos
      end
      if li.text.include? 'Ht.'
          i_ht = li.parent.children.index(li)
          puts i_ht
      end
      if li.text.include? 'Wt.'
          i_wt = li.parent.children.index(li)
          puts i_wt
        end
      if li.text == 'Hometown' || li.text == 'Hometown (High School)' || li.text == 'HOMETOWN / HIGH SCHOOL' || li.text == 'Hometown / High School' || li.text == 'Hometown/High School' || li.text == 'Hometown (Previous School)'
          i_home = li.parent.children.index(li)
          puts i_home
      end
  end
    t_id = 'ctl00_cplhMainContent_dgrdRoster'

end

doc.search("//*[@id='#{t_id}']//tbody/tr").each do |tr|
     p_name = tr.search(".//td[#{i_n}]").text.strip rescue nil
     p_num = tr.search(".//td[#{i_num}]").text.strip rescue nil
     p_yr = tr.search(".//td[#{i_yr}]").text.strip rescue nil
     p_pos = tr.search(".//td[#{i_pos}]").text.strip rescue nil
     p_ht = tr.search(".//td[#{i_ht}]").text.strip rescue nil
     p_wt = tr.search(".//td[#{i_wt}]").text.strip rescue nil
     p_home = tr.search(".//td[#{i_home}]").text.strip rescue nil
     puts "|#{p_name} | #{p_num} | #{p_yr} | #{p_pos} | #{p_ht} | #{p_wt} | #{p_home}|"
end



end



#    player_details = row.search("td").text.strip
#
#
#
#
#puts player_details

		          #  compile_data = [team, followers]
		          #  stats << compile_data
#end
