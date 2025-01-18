module Bill::ValidateHasLineItems
  macro included
    skip_default_validations

    after_save validate_has_line_items

    private def validate_has_line_items(record : {{ T }})
      return unless {{ T }}Status.now_finalized?(status)

      record = {{ T }}Query.preload_line_items(record)
      return unless record.line_items.empty?

      id.add_error Rex.t(:"operation.error.{{ T.name
        .split("::")
        .last
        .underscore
        .id }}_items_empty")

      database.rollback
    end
  end
end
