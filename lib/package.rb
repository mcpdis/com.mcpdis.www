class Package < Ohm::Model
  SECRET = "gAlTFFSO6NZgdr0rnf43V5O0mQR14NxekdSkXudW9ipi4J3VLI2GPvXEfIzoYkb"

  include Ohm::Timestamping

  reference :user, User
  set :formulas, FormulaDictionary

  attr_accessor :formula_ids

  def sorted_formulas
    formulas.sort_by(:title, order: "ALPHA")
  end

  def signature
    Digest::MD5.hexdigest("#{id}#{SECRET}")
  end

  def jar_url
    "#{MCPDIS_HOST}/packages/#{signature}/mcpdis.jar"
  end

private
  def after_create
    super

    if formula_ids.kind_of?(Array)
      formula_ids.each do |id|
        formulas.key.sadd(id)
      end
    end
  end
end
