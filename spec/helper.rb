metrics_class = File.open(File.dirname(__FILE__) + '/../bin/sensu-plugins-azure-burstable-metrics.rb', 'r') { |file| file.read }
metrics_class.sub!('az', 'file')

eval(metrics_class)
