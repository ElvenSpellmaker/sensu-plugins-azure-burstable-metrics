#! /usr/bin/env ruby

require 'json'
require 'parallel'
require 'sensu-plugin/metric/cli'
require 'time'

class BurstableMetrics < Sensu::Plugin::Metric::CLI::Graphite
  option :schema,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: 'sensu'

  option :spn_id,
         description: 'The SPN ID with read access to the subscription',
         short: '-i',
         long: '--spn-id <SPN ID>',
         default: nil

  option :spn_secret,
         description: 'The SPN secret for the SPN ID',
         short: '-p',
         long: '--spn-secret <SPN Secret>',
         default: nil

  option :tenant_id,
         description: 'The Tenant ID for the SPN ID',
         short: '-t',
         long: '--tenant-id <Tenant ID>',
         default: nil

  @@time_format = '%Y-%m-%dT%H:%M:%SZ'

  def initialize(argv = ARGV, metrics_client = 'az')
    super argv

    dir = __FILE__ === '(eval)' ? '.' : "#{__dir__}/../"
    require "#{dir}/lib/provider/#{metrics_client}.rb"
    metrics_upper = metrics_client.capitalize
    @metrics_client = Object.const_get("#{metrics_upper}Client").new
  end

  def run
    @metrics_client.set_credentials(
      config[:spn_id],
      config[:spn_secret],
      config[:tenant_id],
  )

    machines = @metrics_client.vm_list.select! { |machine| machine['hardwareProfile']['vmSize'] =~ /.*B\d{1,2}m?s$/ }

    time = Time.now.utc
    start_time = (time - 120).strftime(@@time_format)
    end_time = (time - 60).strftime(@@time_format)

    Parallel.map(machines, in_threads: 5) { |machine|
      process_machine(machine, time, start_time, end_time)
    }

    ok
  end

private

  def process_machine(machine, time, start_time, end_time)
    machine_id = machine['id']
    machine_name = machine['name']

    metrics = @metrics_client.machine_burstable_metrics(machine_id, start_time, end_time)

    metrics['value'].each_with_index do |metric, index|
      process_metric(machine_name, metric, index, time)
    end
  end

  def process_metric(machine_name, metric, index, time)
    output [config[:schema], machine_name, @metrics_client.graphite_burstable_metrics_list[index]].join('.'), metric['timeseries'][0]['data'][0]['average'], time.to_i
  end
end
