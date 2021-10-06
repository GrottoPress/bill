module Bill::MetadataColumn
  macro included
    column metadata : JSON::Any?
  end
end
