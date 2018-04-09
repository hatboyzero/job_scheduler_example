class JobScheduler
  def process(job)
    job_name = job.keys.first.to_s
    job_dep = job[job_name]
    unless job_dep.empty?
      dep = @jobs.find { |j| j.keys.first.to_s == job_dep }
      unless dep.nil?
        @jobs = @jobs - [dep]
        process(dep)
      end
    end

    @output << job_name
  end

  def execute(job_definition)
    @jobs = job_definition.each_line.map do |line|
      name, dep = line.split('=>').map { |v| v.strip! }
      { name => dep }
    end

    @output = ''
    while @jobs.any?
      process(@jobs.shift(1).first)
    end

    @output
  end
end