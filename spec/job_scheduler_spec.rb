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
    expect(output).to eq('a')
  end

  it 'executes a job definition containing multiple jobs' do
    job_scheduler = JobScheduler.new
    output = job_scheduler.execute <<EOM
a =>
b =>
c =>
EOM
    expect(output).to eq('abc')
  end
end