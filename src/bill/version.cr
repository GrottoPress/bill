module Bill
  {% begin %}
    VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
  {% end %}
end
