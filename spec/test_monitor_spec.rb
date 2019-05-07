RSpec.describe 'BurstableMetrics' do
  context "" do
    it "Parses the JSON data to produce burstable metrics" do
      metrics = %x(ruby spec/helper.rb)

      expected = [
        'sensu.poc-bs-test.cpu_credits_consumed 0.0',
        'sensu.poc-bs-test.cpu_credits_remaining 636.0',
        'sensu.poc-bms-test.cpu_credits_consumed 0.0',
        'sensu.poc-bms-test.cpu_credits_remaining 636.0',
      ].sort!

      metrics.split("\n").sort!.each_with_index do |line, index|
        expect(line).to start_with(expected[index])
      end
    end
  end
end
