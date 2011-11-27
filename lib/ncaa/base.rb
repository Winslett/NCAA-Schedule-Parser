module NCAA
  class Base
    attr_accessor :ncaa_xml, :sports, :schools, :games

    def initialize(xml_string)
      @sports, @schools, @games = {}, {}, []

      ncaa_xml = Nokogiri::HTML(xml_string)

      ncaa_xml.css("select[@name='P_Sport_Code'] option").each do |team_html|
        parse_sport(team_html)
      end

      ncaa_xml.css("select[@name='P_ORGNUM'] option").each do |school_html|
        parse_school(school_html)
      end
    end

    def parse_sport(team_html)
      id, name = team_html["value"], team_html.inner_html.strip

      @sports[id] = NCAA::Sport.new(id, name) if @sports[id].nil?
    end

    def parse_school(school_html)
      id, name = school_html["value"], school_html.inner_html.strip

      @schools[id] = NCAA::School.new(id, name) if @schools[id].nil?
    end

    def add_games(sport_code, school, game_html)
      Nokogiri::HTML(game_html).css("table tr").each do |table_row|
        next unless (table_row.css("td")[3].inner_text.upcase =~ /(HOME|AWAY)/ rescue false)

        other_school = if table_row.css("td")[1].at_css("a").attributes["href"].value =~ /([0-9]+)$/
                         @schools[$1]
                       else
                         table_row.css("td")[1].at_css("a").inner_text
                       end

        home_team, visiting_team = if $1 == "HOME"
                                     [school, other_school]
                                   else
                                     [other_school, school]
                                   end

        date = Time.parse(table_row.css('td')[5..5].inner_text)

        unless @games.find { |g| g.date == date && g.home_team == home_team && g.visiting_team == visiting_team }
          @games << NCAA::Game.new(
              :sport     => @sports[sport_code],
              :home_team => home_team,
              :visiting_team => visiting_team,
              :date      => date
          )
        end
      end
    end
  end
end
