module Bill::SetDefaultQuantity
  macro included
    before_save do
      set_default_quantity
    end

    private def set_default_quantity
      quantity.value = 1 unless quantity.value
    end
  end
end
