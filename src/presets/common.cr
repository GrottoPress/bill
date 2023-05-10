abstract class BaseModel < Avram::Model
  include Bill::Model
end

struct Currency
  include Bill::Currency
end

struct FractionalMoney
  include Bill::FractionalMoney
end
