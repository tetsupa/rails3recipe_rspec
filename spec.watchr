local_notify_setting = File.join(File.dirname(__FILE__), 'notify')
if File.exist?(local_notify_setting + '.rb')
  require local_notify_setting
else
  def notify(message)
    # do nothing
  end
end

def run(cmd)
  system('clear')

  puts cmd
#  puts result = %x(#{cmd}) # todo spawn
#  result.split("\n").last
  system(cmd)
end

def run_spec(file)
  notify(run("rake spec SPEC=#{file}"))
end

def run_all_spec
  notify(run('rake spec'))
end

# for test script
watch('^spec/spec_helper.rb') { run_all_spec }
watch('^spec/support/.*.rb')  { run_all_spec }
watch('^spec/.*_spec.rb')     {|md| run_spec(md[0]) }

watch('^app/controllers/.*.rb') { run_all_spec } # because we will not write spec of controllers
watch('^app/models/(.*).rb')    {|md| run_spec("spec/models/#{md[1]}_spec.rb") }
watch('^lib/(.*).rb')           {|md| run_spec("spec/lib/#{md[1]}_spec.rb") }

# trap
Signal.trap 'QUIT' do
  run_all_spec
end
