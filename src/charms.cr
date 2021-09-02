module Avram
  abstract class SaveOperation(T)
    # Getting rid of default validations in Avram
    #
    # See https://github.com/luckyframework/lucky/discussions/1209#discussioncomment-46030
    #
    # All operations are expected to explicitly define any validations
    # needed
    def valid? : Bool
      custom_errors.empty? && attributes.all?(&.valid?)
    end
  end
end
