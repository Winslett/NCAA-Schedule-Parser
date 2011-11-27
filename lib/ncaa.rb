require 'nokogiri'
require 'time'

module NCAA

  autoload :Base, File.join(File.dirname(__FILE__), 'ncaa', 'base')
  autoload :School, File.join(File.dirname(__FILE__), 'ncaa', 'school')
  autoload :Sport, File.join(File.dirname(__FILE__), 'ncaa', 'sport')
  autoload :Game, File.join(File.dirname(__FILE__), 'ncaa', 'game')

end
