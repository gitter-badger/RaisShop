namespace :db do
  desc "add frequency lists to the database"
  task freq: :environment do
    def add_list(filename, listname)
      puts "populating db with #{listname} from #{filename}"
      words = File.open(filename, "r").read.split
      rank = 0
      words.each do |word|
        Freq.create!(word: word, rank:rank += 1,list:listname )
      end
    end
    add_list("en3.txt", "5K")
  end
end
