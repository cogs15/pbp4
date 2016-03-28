require 'mechanize'

class HttpClient

  def initialize()
    @agent = Mechanize.new{ |agent| agent.history.max_size=0 }
    @agent.user_agent = 'Mozilla/5.0'
    @agent.robots = false
  end

  def wait()
    min = 0.5
    max = 2.5
    time = ((max - min) * rand()) + min
    puts "Sleeping for #{time} seconds"
    sleep time
  end

  def get_html(url, try_number = 1)
    begin
      self.wait()
      print "GET #{url} ... "
      response = @agent.get(url)
      puts "success"
      return Nokogiri::HTML(response.body)
    rescue
      puts "failed"
      if (try_number > 5)
#exit 1
      else
        puts "On try #{try_number} of 5"
        try_number += 1
        retry
      end
    end
  end

end
