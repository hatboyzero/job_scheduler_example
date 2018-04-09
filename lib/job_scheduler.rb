class JobScheduler
  def execute(job_definition)
    output = ''
    job_definition.each_line do |line|
      output << line[0,1]
    end

    output
  end
end