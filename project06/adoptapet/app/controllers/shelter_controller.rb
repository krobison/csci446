class ShelterController < ApplicationController
	include CurrentCart
	before_action :set_cart
  def index
	@pets = Pet.order(:name)
  end
end
