class ShelterController < ApplicationController
  def index
	@pets = Pet.order(:name)
  end
end
