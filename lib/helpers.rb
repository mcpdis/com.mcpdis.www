module MCPDIS
  module Helpers
    def current_user
      authenticated(User)
    end

    def has_error?(model, att)
      model.errors.has_key?(att)
    end

    def send_wap_header!
      headers["Content-Type"] = "application/xhtml+xml"
    end

    def mote_vars(content)
      super.merge(path: req.path)
    end

    def under?(fragment, path)
      path.start_with?(fragment)
    end

    def in?(fragment, path)
      path == fragment
    end

  end
end
