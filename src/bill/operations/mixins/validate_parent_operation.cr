module Bill::ValidateParentOperation
  macro included
    {% parent_model = T.name.split("::").last.gsub(/Item$/, "").id %}

    {% assoc = T.constant(:ASSOCIATIONS).find do |assoc|
      assoc[:relationship_type] == :belongs_to &&
        assoc[:type].resolve.name == parent_model
    end %}

    needs parent : {{ parent_model }}::SaveOperation

    {% if @type < Avram::DeleteOperation %}
      before_delete do
        validate_foreign_key_match
        validate_parent_not_finalized
      end
    {% else %}
      before_save do
        set_foreign_key
        validate_foreign_key_match
        validate_parent_not_finalized
      end
    {% end %}

    private def set_foreign_key
      return if record
      {{ assoc[:foreign_key].id }}.value = parent.record.try(&.id)
    end

    private def validate_foreign_key_match
      return unless record

      parent.record.try do |parent|
        return if parent.id == {{ assoc[:foreign_key].id }}.value
        {{ assoc[:foreign_key].id }}.add_error("is invalid")
      end
    end

    private def validate_parent_not_finalized
      return if {{ parent_model }}Status.now_finalized?(parent.status)

      return parent.record.try do |parent|
        return unless parent.finalized?
        {{ assoc[:foreign_key].id }}.add_error("is finalized")
      end
    end
  end
end
