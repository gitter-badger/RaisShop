class FreqController < ApplicationController
  def get
    word = Freq.find_by_word(params[:word])
    word_id = word.nil? ? 9999 : word.id
    render json: {id: word_id}, callback: params[:callback]
  end
end
