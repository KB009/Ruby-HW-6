# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'SETTING UP ROLES'
[:admin, :user].each do |role|
  Role.where({ name: role }, without_protection: true).first_or_create

unless User.where(:email => 'test@test.com').any? then
  puts 'SETTING UP DEFAULT USER LOGIN'
    user = User.create! :name => "Administrator", :email => 'ruby-hw@email.cz', :password => 'password', :password_confirmation => 'password'
    user.add_role :admin
    puts 'New user created: ' << user.name
end

end

