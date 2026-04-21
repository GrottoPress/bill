{% skip_file unless Avram::Model.all_subclasses.any?(&.name.== :User.id) %}

class User::BaseQuery
  include Bill::UserQuery
end

class UserQuery < User::BaseQuery
end
