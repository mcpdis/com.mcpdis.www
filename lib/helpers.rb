module MCPDIS
  module Helpers
    def current_user
      authenticated(User)
    end  

    def has_error?(model, att)
      model.errors[att].any?
    end
  end
end
