module Bill::ValidateNotFinalized
  macro included
    {% if @type < Avram::DeleteOperation %}
      before_delete do
        validate_not_finalized
      end
    {% else %}
      before_save do
        validate_not_finalized
      end
    {% end %}

    private def validate_not_finalized
      record.try do |record|
        id.add_error("is finalized") if record.finalized?
      end
    end
  end
end
