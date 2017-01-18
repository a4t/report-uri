require 'sinatra'
require 'json'
require 'fluent-logger'
require './lib/slack_notification'
require './lib/csp_report'

csp_report = CspReport.new
slack_notification = SlackNotication.new
fluent_logger = Fluent::Logger::FluentLogger.new(nil, :host=>'fluentd', :port => 24224)
default_response = {
  status: true,
  message: nil
}

get '/csp_report/ping' do
  res = default_response
  res['message'] = 'pong'
  JSON.generate(res)
end

post '/csp_report/' do
  data = JSON.parse(request.body.read)
  data['csp-report'] = csp_report.replase_array_key_hyphen_to_underscore data['csp-report']

  data['csp-report']['host'] = csp_report.host data
  slack_notification_options = slack_notification.set_host_options data['csp-report']['host']
  fluent_data = data['csp-report'].merge(slack_notification_options)

  res = default_response
  unless fluent_logger.post('csp.logger', fluent_data)
    res = {
      status: false,
      message: fluent_logger.last_error
    }
  end

  JSON.generate(res)
end
