class FreqController < ApplicationController
  def get
    words = params[:words].split(",")
    freqs = Array.new
    words.each do |word|
      freq = nil
      Freq.uniq.pluck(:list).each do |list|
        freq ||= Freq.find_by_word_and_list(word, list)
      end
      freqs << ( freq.nil? ? ":(": freq.rank)
    end
    render json: freqs, callback: params[:callback]
  end
end
