class JobScheduler
  def execute(job_definition)
    jobs = job_definition.each_line.map do |line|
      name, dep = line.split('=>').map { |v| v.strip! }
      { name => dep }
    end

    output = ''
    while jobs.any?
      current_job = jobs.shift(1).first
      job_name = current_job.keys.first.to_s
      job_dep = current_job[job_name]
      unless job_dep.empty?
        output << job_dep
        jobs.delete_if { |job| job.keys.first.to_s == job_dep }
      end

      output << job_name
    end

    output
  end
end