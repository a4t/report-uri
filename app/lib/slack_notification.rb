require 'yaml'

class SlackNotication
  CONFIG_FILE = './config/notification.yml'
  OPTION_ITEMS = [
    'slack_channel',
  ]

  def initialize
    @yaml = YAML.load_file(CONFIG_FILE)
    @options = @yaml['notification']['hosts']['default']
  end

  def set_host_options(host)
    host = 'default' if @yaml['notification']['hosts'][host].nil?
    host_options = @yaml['notification']['hosts'][host]
    OPTION_ITEMS.each do | item |
      @options["#{item}"] = host_options[item] unless host_options[item].nil?
    end
    @options
  end
end
