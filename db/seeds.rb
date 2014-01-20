# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
%w(C C++ Java Python Ruby).each do |lang|
  ProgrammingLanguage.create(name: lang)
end

user = User.create( username: "Hola", password: "password", password_confirmation: "password", email: "email@c.com")