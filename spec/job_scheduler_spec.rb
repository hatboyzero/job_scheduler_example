require 'job_scheduler'

RSpec.describe JobScheduler, '#execute' do
  before(:each) do
    @job_scheduler = JobScheduler.new
  end

  it 'executes an empty job definition' do
    output = @job_scheduler.execute ''
    expect(output).to be_a(String)
    expect(output).to be_empty
  end

  it 'executes a job definition containing a single job' do
    output = @job_scheduler.execute 'a => '
    expect(output).to be_a(String)
    expect(output).to eq('a')
  end

  it 'executes a job definition containing multiple jobs' do
    output = @job_scheduler.execute <<EOM
a =>
b =>
c =>
EOM
    expect(output).to be_a(String)
    expect(output).to eq('abc')
  end

  it 'executes a job definition containing multiple jobs with dependencies' do
    output = @job_scheduler.execute <<EOM
a => 
b => c
c =>
EOM
    expect(output).to be_a(String)
    expect(output).to eq('acb')
  end
end