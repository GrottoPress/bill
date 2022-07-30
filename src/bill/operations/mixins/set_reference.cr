module Bill::SetReference
  macro included
    after_save set_reference

    private def set_reference(saved_record)
      self.record = Update{{ T }}Reference.update!(saved_record)
    end
  end
end
