module Bill::ValidateReference
  macro included
    before_save do
      validate_reference_unique
    end

    private def validate_reference_unique
      return unless reference.changed?

      reference.value.try do |value|
        query = {{ T }}Query.new
        record.try { |_record| query = query.id.not.eq(_record.id) }

        return if query.reference.lower.eq(value.downcase).none?

        reference.add_error Rex.t(
          :"operation.error.reference_exists",
          reference: value
        )
      end
    end
  end
end
