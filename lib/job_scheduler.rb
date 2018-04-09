class JobScheduler
  def process(job)
    job_name = job.keys.first.to_s
    job_dep = job[job_name]

    @stack.push job_name
    unless job_dep.empty?
      if @stack.include? job_dep
        raise CircularDependencyError.new
      end

      dep = @jobs.find { |j| j.keys.first.to_s == job_dep }
      unless dep.nil?
        @jobs = @jobs - [dep]
        process(dep)
      end
    end

    @output << job_name
    @stack.pop
  end

  def execute(job_definition)
    @stack = []
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