require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @question = params[:question]
    @letters = params[:letters]
    @test = run_game(@question, @letters)
  end

  private

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result
    result = {}

    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    url_serialized = open(url).read
    word_check = JSON.parse(url_serialized)

    word = attempt.upcase.chars

    if word.all? { |letter| word.count(letter) <= grid.count(letter) }
      if word_check["found"] == false
        result[:message] = "Not an english word."
        result[:score] = 0
      else
        result[:message] = "Well done."
        result[:score] = word.length * 2
      end
    else
      result[:message] = "Not in the grid"
      result[:score] = 0
    end
    result
  end
end
