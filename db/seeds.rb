# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'Start seeds!'

(1..5).each do |i|
  fake_data = {
    title: Faker::Name.title,
    description: Faker::Lorem.paragraphs(4, true).join("\n"),
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.email,
  }
  Job.create!(fake_data)
end
