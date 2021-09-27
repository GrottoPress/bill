module Bill::ValidateFinalized
  macro included
    {% if @type < Avram::DeleteOperation %}
      before_delete do
        validate_finalized
      end
    {% else %}
      before_save do
        validate_finalized
      end
    {% end %}

    private def validate_finalized
      record.try do |record|
        id.add_error("is not finalized") unless record.finalized?
      end
    end
  end
end
