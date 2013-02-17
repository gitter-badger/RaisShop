namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    puts 'SETTING UP DEFAULT ADMIN LOGIN and 100 regular users'
    password = "password"
    admin = User.create!(
      email: "admin@admin.com",
      password: password,
      password_confirmation: password,
        addresses_attributes:[{
          full_name: "Volodymyr Barna"
        }])
    admin.toggle!(:admin)

    100.times do |n|
      User.create(
        email: "admin#{n}@admin.com",
        password:password,
        password_confirmation:password,
        addresses_attributes:[{
          full_name: "#{Faker::Name.first_name} #{Faker::Name.last_name}"
        }])
    end

    def make_categories
      categories = ["Computers & Networking", "Cell Phones & PDAs",
        "Cameras & Photo", "Video & Audio", "More Electronics",
        "Books", "Video Games",].sort!
      categories.each do |category|
        Category.create!(name:category)
      end
    end
    puts "Making a few categories"
    make_categories

    puts "Adding 3 Pragmatic books"
    book_category = Category.find_by_name("Books").id
    Product.create(title: 'CoffeeScript',
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
    Product.create(title: 'Programming Ruby 1.9',
                   description:
                   %{
        Ruby is the fastest growing and most exciting dynamic language
        out there. If you need to get working programs delivered fast,
        you should add Ruby to your toolbox.
    },
      image_url: 'ruby.jpg',
      category_id: book_category,               price: 49.95)
    Product.create(title: 'Rails Test Prescriptions',
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
    puts "Adding 1k fake products"
    1000.times.each do |n|
      Product.create(title: Faker::Lorem.words(1+rand(5)).join(" ").capitalize,
                     description: Faker::Lorem.sentence(30),
                     image_url:'ruby.jpg',
                     category_id:Category.all.sample.id,
                     price:rand(599..1500099) / 100.0)
    end
    puts "Adding 0..3 reviews for each product"
    Product.all.each do |product|
      rand(4).times do
        review = product.reviews.build(comment: Faker::Lorem.sentence(10),
                                       rating:  1 + rand(5),
                                       user_id: 1 + rand(50))
        review.save
      end
    end
  end
end