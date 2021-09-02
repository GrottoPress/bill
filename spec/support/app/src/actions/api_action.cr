abstract class ApiAction
  accepted_formats [:html, :json], default: :json

  route_prefix "/api/v0"
end
