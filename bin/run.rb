require 'CSV'
require_relative '../config/environment.rb'


# CSV.foreach('/Users/annamester/Development/code/module-one-final-project-guidelines-nyc-web-060319/db/organizations.csv', headers: true) do |row|
#     Company.create(name: row[1], location: row[12])
# end


cli = CLI.new

cli.welcome
