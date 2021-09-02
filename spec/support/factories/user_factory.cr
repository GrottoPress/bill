class UserFactory < Avram::Factory
  def initialize
    set_defaults
  end

  private def set_defaults
    email "user@domain.tld"
  end
end
