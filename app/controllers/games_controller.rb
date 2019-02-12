require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].chars
    @word = params[:word].upcase
    if not_in_grid?(@word, @letters)
      @result = 1
    elsif dictionary(@word)
      @result = 2
    else
      @result = 0
    end
  end
end

private

def not_in_grid?(word, letters)
  letters_combinations = letters.combination(word.length).to_a
  attempt_characters = word.chars
  result = true
  letters_combinations.each do |combination|
    if combination.sort == attempt_characters.sort
      result = false
      break
    end
  end
end

def dictionary(word)
  url = "https://wagon-dictionary.herokuapp.com/#{word}"
  word = URI.open(url).read
  !JSON.parse(word)['found']
end
