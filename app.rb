MCPDIS_ROOT = File.expand_path(File.dirname(__FILE__))
MCPDIS_HOST = ENV["MCPDIS_HOST"] || "http://localhost:8080"

require_relative "shotgun"

Dir["./lib/**/*.rb"].each { |rb| require rb }

Cuba.use Rack::Static,
  urls: ["/img", "/style", "/js", "/packages"],
  root: "./public"

Cuba.use Rack::Session::Cookie,
  key: "mcpdis",
  secret: "PpBcxD2cZ2mKX2JZxC5HlSw63cdWtWAdqiWhAwGFenUvkQuRiPsSeWhyVTqHCZN"

Cuba.plugin Cuba::Prelude
Cuba.plugin Cuba::Mote
Cuba.plugin Shield::Helpers
Cuba.plugin MCPDIS::Helpers

Cuba.define do
  persist_session!

  on "login" do
    on get do
      if req[:redirect] && req[:redirect] =~ %r{/[a-z]+}
        session[:redirect_to] = req[:redirect]
      end

      res.write view("login", email: nil)
    end

    on post do
      if login(User, req[:email], req[:password], req[:remember])
        res.redirect session.delete(:redirect_to) || "/"
      else
        session[:error] = "Invalid username and/or password combination."
        res.write view("login", email: req[:email])
      end
    end
  end

  on "signup" do
    on get do
      res.write view("signup", user: CreateUser.new({}))
    end

    on post, param("user") do |atts|
      user = CreateUser.new(atts)

      if user.valid?
        authenticate(user.create)
        res.redirect "/dashboard", 303
      else
        res.write view("signup", user: user)
      end
    end
  end

  on "download" do
    on :id do |id|
      ensure_authenticated(User)

      package = Package[id]

      res.write view("download-success", package: package)
    end

    on post, param("formulas") do |formula_ids|
      ensure_authenticated(User)

      package = Package.create(user: current_user, formula_ids: formula_ids)
      Compiler.build(package)

      res.redirect "/download/#{package.id}", 303
    end

    on default do
      res.write view("download", formulas: FormulaDictionary.all)
    end
  end

  on "" do
    res.write view("home")
  end

  on "api/v1" do
    run API
  end

  on default do
    ensure_authenticated(User)

    on "dashboard" do
    end

    on "logout" do
      logout(User)
      res.redirect "/", 303
    end

    on "apps" do
      res.write view("apps", packages: current_user.latest_packages)
    end

    on "patients" do
      res.write view("patients", patients: current_user.patients)
    end

    on "formulas" do
      res.write view("formulas", formulas: current_user.formulas)
    end
  end
end
