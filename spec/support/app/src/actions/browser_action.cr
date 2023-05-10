abstract class BrowserAction < Lucky::Action
  include Bill::BrowserAction

  accepted_formats [:html, :json], default: :html
end
