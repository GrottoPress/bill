module Bill::ValidateParentRecord
  macro included
    {% parent_model = T.name.split("::").last.gsub(/Item$/, "").id %}

    {% assoc = T.constant(:ASSOCIATIONS).find do |assoc|
      assoc[:relationship_type] == :belongs_to &&
        assoc[:type].resolve.name == parent_model
    end %}

    {% if @type < Avram::DeleteOperation %}
      before_delete do
        validate_parent_not_finalized
      end
    {% else %}
      skip_default_validations

      before_save do
        validate_parent_not_finalized
      end
    {% end %}

    private def validate_parent_not_finalized
      record.try do |record|
        return unless record.{{ assoc[:assoc_name].id }}.finalized?

        {{ assoc[:foreign_key].id }}.add_error Rex.t(
          :"operation.error.{{ parent_model.underscore }}_finalized",
          {{ assoc[:foreign_key].id }}: record.id,
          status: record.{{ assoc[:assoc_name].id }}.status.to_s
        )
      end
    end
  end
end
