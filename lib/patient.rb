class Patient < Ohm::Model
  include Ohm::Timestamping
  include Ohm::DataTypes

  attribute :first_name
  attribute :last_name
  attribute :gender
  attribute :date_of_birth, Type::Timestamp
  attribute :remote_id

  unique :identifier

  reference :user, User

  def identifier
    model.identifier(user_id, remote_id)
  end

  def self.identifier(uid, id)
    "#{uid}--#{id}"
  end

  def self.archive(user, id, atts)
    patient = with(:identifier, identifier(user.id, id))

    if not patient
      patient = new(remote_id: id, user_id: user.id)
    end

    patient.update(atts)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
