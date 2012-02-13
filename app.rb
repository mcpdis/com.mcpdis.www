require_relative "shotgun"

Dir["./lib/**/*.rb"].each { |rb| require rb }

Cuba.use Rack::Static,
  urls: ["/img", "/style", "/js"],
  root: "./public"

Cuba.use Rack::Session::Cookie,
  key: "mcpdis",
  secret: "PpBcxD2cZ2mKX2JZxC5HlSw63cdWtWAdqiWhAwGFenUvkQuRiPsSeWhyVTqHCZN"

Cuba.plugin Cuba::Mote
Cuba.plugin Shield::Helpers
Cuba.plugin MCPDIS::Helpers

Cuba.define do
  on "login" do
    on get do
      res.write view("login")
    end
  end

  on "logout" do
    logout(User)
    res.redirect "/", 303
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

  on "dashboard" do
  end

  on "download" do
  end

  on "" do
    res.write view("home")
  end
end
