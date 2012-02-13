require_relative "shotgun"

Dir["./lib/**/*.rb"].each { |rb| require rb }

Cuba.use Rack::Static,
  urls: ["/img", "/style", "/js"],
  root: "./public"

Cuba.use Rack::Session::Cookie,
  key: "mcpdis",
  secret: "PpBcxD2cZ2mKX2JZxC5HlSw63cdWtWAdqiWhAwGFenUvkQuRiPsSeWhyVTqHCZN"

Cuba.plugin Cuba::Prelude
Cuba.plugin Cuba::Mote
Cuba.plugin Shield::Helpers
Cuba.plugin MCPDIS::Helpers

Cuba.define do
  on "login" do
    on get do
      if req[:redirect] && req[:redirect] =~ %r{/[a-z]+}
        session[:redirect_to] = req[:redirect]
      end

      res.write view("login", email: nil)
    end

    on post do
      if login(User, req[:email], req[:password])
        res.redirect session.delete(:redirect_to) || "/"
      else
        session[:error] = "Invalid username and/or password combination."
        res.write view("login", email: req[:email])
      end
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
    on "success" do
      res.write view("download-success")
    end

    on get do
      res.write view("download", formulas: FormulaDictionary.all)
    end

    on post do
      sleep 5
      res.redirect "/download/success", 303
    end
  end

  on "" do
    res.write view("home")
  end
end
