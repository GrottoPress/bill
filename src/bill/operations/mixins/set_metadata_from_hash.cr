module Bill::SetMetadataFromHash
  macro included
    needs metadata_hash : Hash(String, String)

    before_save do
      set_metadata
    end

    private def set_metadata
      return if metadata_hash.empty?
      metadata.value = JSON.parse(metadata_hash.to_json)
    end
  end
end
