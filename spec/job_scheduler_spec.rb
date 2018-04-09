require 'job_scheduler'

RSpec.describe JobScheduler, '#execute' do
  it 'executes an empty job definition' do
    job_scheduler = JobScheduler.new
    output = job_scheduler.execute ''
    expect(output.is_a?(String) && output.empty?)
  end

  it 'executes a job definition containing a single job' do
    job_scheduler = JobScheduler.new
    output = job_scheduler.execute 'a => '
    print output
    expect(output).to eq('a')
  end
end