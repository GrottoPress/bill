{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("User")
%}

class UserQuery < User::BaseQuery
  include Bill::UserQuery
end
