require 'job_scheduler'
require 'circular_dependency_error'

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

  it 'executes a job definition containing multiple jobs with nested dependencies' do
    output = @job_scheduler.execute <<EOM
a =>
b => c
c => f
d => a
e => b
f =>
EOM
    expect(output).to be_a(String)
    expect(output).to eq('afcbde')
  end

  it 'generates an error on jobs that depend on themselves' do
    job_definition = <<EOM
a => 
b =>
c => c
EOM
    expect{@job_scheduler.execute job_definition}.to raise_error(CircularDependencyError)
  end

  it 'generates an error on jobs that have circular dependencies' do
    job_definition = <<EOM
a =>
b => c
c => f
d => a
e =>
f => b
EOM
    expect{@job_scheduler.execute job_definition}.to raise_error(CircularDependencyError)
  end
end