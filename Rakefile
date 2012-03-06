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

task :flush do
  system("redis-cli flushall")
end

task :cleanup do
  system("rm -rf public/packages/*")
  system("rm -rf /home/cyx/j2mewtk/2.5.2/apps/mcpdis")
end

task :reset_downloads do
  system("rm -rf /home/cyx/Downloads/mcpdis*")
end

task :reset => [:flush, :cleanup, :reset_downloads, :setup]
