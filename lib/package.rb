class Package < Ohm::Model
  reference :user, User
  set :formulas, FormulaDictionary
end
