class BaseClient
  @@burstable_metrics = ['CPU Credits Consumed', 'CPU Credits Remaining'].freeze
  @@burstable_metrics_list = @@burstable_metrics.join(',').freeze
  @@output_burstable_metrics = @@burstable_metrics.map { |metric| metric.downcase.gsub!(' ','_') }.freeze

  def set_credentials(spn_id = nil, spn_secret = nil, tenant_id = nil)
    @spn_id = spn_id
    @spn_secret = spn_secret
    @tenant_id = tenant_id
  end

  def graphite_burstable_metrics_list
    @@output_burstable_metrics
  end

end
