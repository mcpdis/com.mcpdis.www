class Patient < Ohm::Model
  include Ohm::Timestamping
  include Ohm::DataTypes

  attribute :first_name
  attribute :last_name
  attribute :gender
  attribute :date_of_birth, Type::Date

  reference :user, User
end
