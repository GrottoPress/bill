struct FailureSerializer < BaseSerializer
  def initialize(
    @errors : Hash(Symbol, Array(String))? = nil,
    @many_nested_errors : Hash(
      Symbol,
      Array(Hash(Symbol, Array(String)))
    )? = nil,
    @message : String? = nil
  )
  end

  private def status : Status
    Status::Failure
  end

  private def data_json : NamedTuple
    data = super
    data = add_errors(data)
    data = add_many_nested_errors(data)
    data
  end

  private def add_errors(data)
    @errors.try do |errors|
      data = data.merge({errors: errors})
    end

    data
  end

  private def add_many_nested_errors(data)
    @many_nested_errors.try do |many_nested_errors|
      data = data.merge({many_nested_errors: many_nested_errors})
    end

    data
  end
end
