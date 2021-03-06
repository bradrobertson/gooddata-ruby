#!/usr/bin/env ruby

require 'gooddata'
require 'gooddata/command'

require 'irb'

include GoodData

module IRB
  def IRB.start2(bind, ap_path)
    IRB.setup(ap_path)
    irb = Irb.new(WorkSpace.new(bind))
    @CONF[:MAIN_CONTEXT] = irb.context
    trap("SIGINT") do
      irb.signal_handle
    end
    catch(:IRB_EXIT) do
      irb.eval_input
    end
  end
end

param = ARGV.shift if ARGV.length
if param == '--debug' then
  require 'logger'
  GoodData.logger = Logger.new STDOUT
end
Command.connect
puts "Logged into GoodData as #{GoodData.profile.user} (#{GoodData.profile['login']})"
puts
IRB::start2 binding, $STDIN
puts "Logging out"
