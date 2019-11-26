# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

dummyItem = ["Furniture", "Chair", "Dummy Chair"]

# for faster generation
# you cannot login as seeded users!
BCrypt::Engine.cost=(1)
dummyUsers = []
for x in 1...2000
    randEmail = Array.new(10){[*"A".."Z", *"0".."9"].sample}.join + "#{x}" + "@abc.com"
    user = User.new(name: "dummyUser#{x}", email: randEmail, password: 'hello123')
    dummyUsers << user
    print "\r #{x} users created"
end
puts ''
puts 'dummy users created'
User.import dummyUsers
puts 'dummy users imported'

items = []
image_fid = File.open(File.join(Rails.root, 'app','assets','images', 'Chair.jpeg'))
for x in 1...2000
    randID = rand(1..100)
    i = Item.new(category: dummyItem[0], name: dummyItem[1], user_id: randID, description: dummyItem[2])
    i.images.attach(io: image_fid, filename: 'dummyChair.jpg')
    image_fid.seek(0, IO::SEEK_SET)
    i.save
    print "\r #{x} items created"
end

puts ''
puts 'dummy items created'
puts 'dummy items imported'
