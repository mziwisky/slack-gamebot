$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'slack-gamebot'

Thread.new do
  begin
    SlackGamebot::App.instance.run
  rescue Exception => e
    STDERR.puts "#{e.class}: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

require 'slack-gamebot/web/web'

run Rack::Cascade.new [Api::Middleware.instance, Web]
