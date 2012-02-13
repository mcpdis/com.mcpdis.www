module MCPDIS
  module Helpers
    def current_user
      authenticated(User)
    end

    def has_error?(model, att)
      model.errors[att].any?
    end

    def send_wap_header!
      headers["Content-Type"] = "application/xhtml+xml"
    end
  end
end
