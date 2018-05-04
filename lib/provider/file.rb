require_relative 'base'
require 'json'

class FileClient < BaseClient
  def vm_list
    file_get_contents('spec/vm_list.json')
  end

  def machine_burstable_metrics(machine_id, start_time, end_time)
    file_get_contents('spec/machine_burstable_metrics.json')
  end

  private

  def file_get_contents(file_name)
    JSON.parse(File.open(file_name, 'r') { |file| file.read })
  end
end
