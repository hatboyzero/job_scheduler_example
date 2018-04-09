class CircularDependencyError < StandardError
  def initialize(msg="Circular dependency error")
    super
  end
end