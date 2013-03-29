require 'benchmark'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    puts "resetting db"
    Rake::Task['db:reset'].invoke
    Rake::Task['db:test:prepare'].invoke

    make_users
    make_categories
    make_products
    make_reviews
    make_pragmatic_books
  end
end

def make_users(users = 10)
  puts "SETTING UP DEFAULT ADMIN LOGIN and #{users} regular users"
  password = "password"
  admin = User.create!(
    full_name: "Volodymyr Barna",
    email: "admin@admin.com",
    password: password,
    password_confirmation: password,
      addresses_attributes:[{
        line_1: 'Ruska 10/18',
        city: 'Ternopil',
        country: 'Ukraine',
        phone_number: '+380970377658',
        postcode: '46000'
      }])
  admin.toggle!(:admin)

  users.times do |n|
    User.create!(
      full_name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
      email: "admin#{n}@admin.com",
      password:password,
      password_confirmation:password,
      addresses_attributes:[{
        line_1: "#{Faker::Address.street_address}",
        city: "#{Faker::Address.city}",
        country: "#{Faker::Address.country}",
        phone_number: "#{Faker::PhoneNumber.cell_phone}",
        postcode: "#{Faker::Address.postcode}"
      }])
  end
end

def make_categories
  puts "Making a few categories"
  categories = ["Computers & Networking", "Cell Phones & PDAs",
    "Cameras & Photo", "Video & Audio", "More Electronics",
    "Books", "Video Games",].sort!
  categories.each do |category|
    Category.create!(name:category)
  end
end

def make_products
  puts "Adding 1k fake products"
  1000.times.each do |n|
    Product.create!(title: Faker::Lorem.words(1+rand(5)).join(" ").capitalize,
                   description: Faker::Lorem.sentence(30),
                   image_url:'ruby.jpg',
                   category_id:Category.all.sample.id,
                   price:rand(599..1500099) / 100.0)
  end
end

def make_reviews
  puts "Adding 0..3 reviews for each product"
  Product.all.each do |product|
    rand(4).times do
      review = User.all.sample.reviews.build(comment: Faker::Lorem.sentence(10),
                                     rating:  1 + rand(5),
                                     product_id: product.id)
      review.save!
    end
  end
end

def make_pragmatic_books
    puts "Adding 3 Pragmatic books"
    book_category = Category.find_by_name("Books").id
    Product.create!(title: 'CoffeeScript',
                   description:
                   %{
            CoffeeScript is JavaScript done right. It provides all of JavaScript's
      functionality wrapped in a cleaner, more succinct syntax. In the first
      book on this exciting new language, CoffeeScript guru Trevor Burnham
      shows you how to hold onto all the power and flexibility of JavaScript
      while writing clearer, cleaner, and safer code.
                  },
                  image_url: 'cs.jpg',
                  category_id: book_category,
                  price: 36.00)
    Product.create!(title: 'Programming Ruby 1.9',
                   description:
                   %{
        Ruby is the fastest growing and most exciting dynamic language
        out there. If you need to get working programs delivered fast,
        you should add Ruby to your toolbox.
                  },
                  image_url: 'ruby.jpg',
                  category_id: book_category,               price: 49.95)
    Product.create!(title: 'Rails Test Prescriptions',
                   description:
                   %{
        Rails Test Prescriptions is a comprehensive guide to testing
        Rails applications, covering Test-Driven Development from both a
        theoretical perspective (why to test) and from a practical perspective
        (how to test effectively). It covers the core Rails testing tools and
        procedures for Rails 2 and Rails 3, and introduces popular add-ons,
        including Cucumber, Shoulda, Machinist, Mocha, and Rcov.
                  },
                  image_url: 'rtp.jpg',
                  category_id: book_category,               price: 34.95)
end