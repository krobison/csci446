class LineItem < ActiveRecord::Base
  belongs_to :pet
  belongs_to :cart
end
