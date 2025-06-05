module Bill::ValidateParentRecord
  macro included
    {% parent_model = T.name.gsub(/Item$/, "") %}

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
      after_save validate_parent_not_finalized
    {% end %}

    private def validate_parent_not_finalized
      parent_record = record.{{ assoc[:assoc_name].id }}
      return unless parent_record.finalized?

      add_assoc_error(record, parent_record)
    end

    private def validate_parent_not_finalized(saved_record)
      parent_record = saved_record.{{ assoc[:assoc_name].id }}!
      return unless parent_record.finalized?

      add_assoc_error(saved_record, parent_record)

      {%if compare_versions(Avram::VERSION, "1.4.0") >= 0 %}
        write_database.rollback
      {% else %}
        database.rollback
      {% end %}
    end

    private def add_assoc_error(record, parent_record)
      {{ assoc[:foreign_key].id }}.add_error Rex.t(
        :"operation.error.{{ parent_model.split("::")
          .last
          .underscore
          .id }}_finalized",
        {{ assoc[:foreign_key].id }}: record.id,
        status: parent_record.status.to_s
      )
    end
  end
end
