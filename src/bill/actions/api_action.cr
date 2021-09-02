module Bill::ApiAction
  macro included
    include Lucky::Paginator::BackendHelpers
  end
end
