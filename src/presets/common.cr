abstract class BaseModel < Avram::Model
  include Bill::Model
end

abstract class BrowserAction < Lucky::Action
  include Bill::BrowserAction
end

abstract class ApiAction < Lucky::Action
  include Bill::ApiAction
end

struct Currency
  include Bill::Currency
end

struct FractionalMoney
  include Bill::FractionalMoney
end
