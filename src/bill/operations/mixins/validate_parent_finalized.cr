module Bill::ValidateParentFinalized
  macro included
    skip_default_validations

    {% parent_model = T.name.gsub(/Item$/, "") %}

    {% assoc = T.constant(:ASSOCIATIONS).find do |assoc|
      assoc[:relationship_type] == :belongs_to &&
        assoc[:type].resolve.name == parent_model
    end %}

    {% if @type < Avram::DeleteOperation %}
      before_delete do
        validate_parent_finalized
      end
    {% else %}
      before_save do
        validate_parent_finalized
      end
    {% end %}

    private def validate_parent_finalized
      record.try do |record|
        return if record.{{ assoc[:assoc_name].id }}.finalized?

        {{ assoc[:foreign_key].id }}.add_error Rex.t(
          :"operation.error.{{ parent_model.split("::")
            .last
            .underscore
            .id }}_not_finalized",
          {{ assoc[:foreign_key].id }}: record.id,
          status: record.{{ assoc[:assoc_name].id }}.status.to_s
        )
      end
    end
  end
end
