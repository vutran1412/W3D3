require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ShortenedUrl.destroy_all
User.destroy_all
Visit.destroy_all

users = []
10.times do
  users << User.create(email: Faker::Internet.email)
end

urls = []
users.each do |user|
  urls << ShortenedUrl.create!(user, Faker::String.random)
end

users.reverse_each do |user|
  Visit.record_visit!(user, urls.first)
end
