class API < Cuba
  def decode(str)
    Base64.decode64(str)
  end

  def mass_decode(*atts)
    atts.map { |att| decode(req[att]) }
  end

  define do
    on "formulas/archive" do
      name, result, email, hash_code =
        mass_decode(:name, :result, :userEmail, :hashCode)

      break unless user = User.identify(email, hash_code)

      Formula.archive(user, req[:id], req[:patient_id],
        name: name, result: result, timestamp: req[:timestamp])
    end

    on "patients/archive" do
      fname, lname, email, hash_code =
        mass_decode(:firstName, :lastName, :userEmail, :hashCode)

      break unless user = User.identify(email, hash_code)

      Patient.archive(user, req[:id],
        first_name: fname, last_name: lname,
        gender: req[:gender], date_of_birth: req[:dateOfBirth])
    end
  end
end
