# Ensure the agent is started using Unicorn.
# This is needed when using Unicorn and preload_app is not set to true.
# See https://newrelic.com/docs/ruby/no-data-with-unicorn
STDOUT.puts "RPM detected environment: #{NewRelic::LocalEnvironment.new}, RAILS_ENV: #{Rails.env}"
if defined? Unicorn
  ::NewRelic::Agent.manual_start()
  ::NewRelic::Agent.after_fork(:force_reconnect => true)
end
