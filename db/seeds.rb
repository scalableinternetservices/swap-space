# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

dummyItem = ["Furniture", "Chair", "Dummy Chair"]

for x in 1...100
    randEmail = Array.new(10){[*"A".."Z", *"0".."9"].sample}.join + "@abc.com"
    User.create(name: "dummyUser#{x}", email: randEmail, password: "hello123")
end

for x in 1...100
    randID = rand(1..100)
    i = Item.create(category: dummyItem[0], name: dummyItem[1], user_id: randID, description: dummyItem[2])
    i.images.attach(io: File.open(File.join(Rails.root, 'app','assets','images', 'Chair.jpeg')), filename: 'dummyChair.jpg')
end