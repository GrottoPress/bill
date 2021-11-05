module Bill::Metadata
  macro included
    include JSON::Serializable
    include JSON::Serializable::Unmapped

    forward_missing_to json_unmapped
  end
end
