class Formula < Ohm::Model
  include Ohm::DataTypes

  attribute :name
  attribute :result
  attribute :remote_id
  attribute :patient_id
  attribute :timestamp, Type::Timestamp

  unique :identifier

  reference :user, User

  def identifier
    model.identifier(user_id, remote_id, patient_id)
  end

  def self.identifier(uid, id, patient_id)
    "#{uid}--#{id}--#{patient_id}"
  end

  def self.archive(user, id, patient_id, atts)
    formula = with(:identifier, identifier(user.id, id, patient_id))

    if not formula
      formula = new(patient_id: patient_id, remote_id: id, user_id: user.id)
    end

    formula.update(atts)
  end
end
