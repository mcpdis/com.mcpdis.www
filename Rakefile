task :default => :test

task :test do
  require "cutest"

  Cutest.run(Dir["test/*.rb"])
end

task :setup do
  require "csv"
  require "./app"

  CSV.foreach("db/formulas.txt") do |row|
    FormulaDictionary.create(title: row[0], classname: row[1])
    print "."
  end

  puts "\n=> Imported Formulas"
end
