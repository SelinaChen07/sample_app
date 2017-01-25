# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name:"Example User", email: "example@railstutorial.org", password: "password", password_confirmation: "password")

User.create!(name:"Selina Chen", email: "chen@gmail.com", password: "123456", password_confirmation: "123456", admin: true)

98.times do |n|
	name = Faker::Name.name
	User.create!(name: name, email: "example-#{n+2}@railstutorial.org", password: "password", password_confirmation: "password")
end

