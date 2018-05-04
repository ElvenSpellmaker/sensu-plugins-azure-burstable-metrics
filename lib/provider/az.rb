require_relative 'base'
require 'json'

class AzClient < BaseClient
  def vm_list
    az('vm list')
  end

  def machine_burstable_metrics(machine_id, start_time, end_time)
    az("monitor metrics list --resource #{machine_id} --metric '#{@@burstable_metrics_list}' --interval PT1M --start-time #{start_time} --end-time #{end_time}")
  end

private

  def az(command)
    az_output = %x(#{__dir__}/az.bash -c "#{command}" -i "#{@spn_id}" -p "#{@spn_secret}" -t "#{@tenant_id}")
    JSON.parse(az_output)
  end
end
