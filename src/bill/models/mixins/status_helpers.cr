module Bill::StatusHelpers
  def now_finalized?(status : Avram::Attribute)
    status.value.try do |value|
      return false unless value.finalized?
      !status.original_value.try(&.finalized?)
    end
  end
end
