namespace :db do
  desc "add frequency lists to the database"
  task freq: :environment do
    puts "BEGIN"
    words = File.open("en3.txt", "r").read.split
    words.each do |word|
      Freq.create!(word: word)
    end
  end
end
