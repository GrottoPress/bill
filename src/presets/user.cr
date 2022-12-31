{% skip_file unless Avram::Model.all_subclasses.find(&.name.== :User.id) %}

class UserQuery < User::BaseQuery
  include Bill::UserQuery
end
