Lucky::ForceSSLHandler.configure do |settings|
  settings.enabled = LuckyEnv.production?
end
