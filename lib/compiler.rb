class Compiler
  include Ohm::Locking

  PROJECT    = "/srv/mcpdis"
  PROPERTIES = "/srv/mcpdis/nbproject/project.properties"
  JAD_FILE   = "/srv/mcpdis/dist/mcpdis.jad"
  JAR_FILE   = "/srv/mcpdis/dist/mcpdis.jar"

  ANT        = File.join(ANT_HOME, "bin", "ant")
  JAVA       = File.join(JAVA_HOME, "bin", "java")

  TEMPLATE   = File.join(MCPDIS_ROOT, "config/template.project.properties")
  MARKER     = "{{{{ MIDLETS }}}}"
  LINEFORMAT = "MIDlet-%d: %s, , %s\\n"

  TARGET     = File.join(MCPDIS_ROOT, "public/packages/%s")

  attr :package
  attr :target

  def self.build(package)
    new(package).build
  end

  def initialize(package)
    @package = package
    @target  = TARGET % package.signature
  end

  def build
    mutex(5) do
      rewrite_project_properties!

      FileUtils.chdir(PROJECT) do
        %x{env JAVA_HOME=#{JAVA_HOME} #{ANT}}
      end

      FileUtils.mkdir_p(target)

      FileUtils.mv(JAD_FILE, target)
      FileUtils.mv(JAR_FILE, target)

      write_mobile_jad!
    end
  end

  def write_mobile_jad!(origin = "mcpdis.jad", mobile = "mobile.mcpdis.jad")
    jad = File.read(File.join(target, origin), encoding: "utf-8")
    jad.gsub!(/mcpdis.jar$/, package.jar_url)

    File.open(File.join(target, mobile), "w") do |file|
      file.write jad
    end
  end

  def rewrite_project_properties!
    File.open(PROPERTIES, "w") do |file|
      file.write(project_properties)
    end
  end

  def project_properties
    File.read(TEMPLATE, encoding: "utf-8").gsub(MARKER, midlet_properties)
  end

  def midlet_properties
    midlets +
      "FormulaArchiveUrl: #{MCPDIS_HOST}/api/v1/formulas/archive\\n" +
      "PatientArchiveUrl: #{MCPDIS_HOST}/api/v1/patients/archive\\n" +
      "UserEmail: #{package.user.email}\\n" +
      "HashCode: #{package.user.hash_code}\\n"
  end

  def midlets
    "".tap do |ret|
      package.sorted_formulas.each_with_index do |formula, idx|
        ret << LINEFORMAT % [idx + 1, formula.title, formula.classname]
      end
    end
  end

  def key
    @key ||= Nest.new(:Compiler, Ohm.redis)
  end
end
