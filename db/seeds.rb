# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'Start seeds!'

tags = 10.times.map { Faker::Commerce.department(1, true) }

20.times do
  fake_data = {
    title: Faker::Name.title,
    description: Faker::Lorem.paragraphs(4, true).join("\n"),
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.email,
    salary: Faker::Number.between(22, 300) * 1000,
    all_tags: tags.sample(3).join(', ')
  }
  fake_job = Job.create!(fake_data)
end

