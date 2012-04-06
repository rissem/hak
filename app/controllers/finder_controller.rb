class FinderController < ApplicationController
  def index
  end

  def search
    puts 
    render :json => {:stuff => "cool"}
  end
end
