
require 'test_helper'

class PetTest < ActiveSupport::TestCase
	fixtures :pets
	
  test "pet attributes must not be empty" do
    pet = Pet.new
    assert pet.invalid?
	assert pet.errors[:petkind].any?
    assert pet.errors[:name].any?
    assert pet.errors[:description].any?
    assert pet.errors[:price].any?
    assert pet.errors[:image_url].any?
  end

  test "Pet price must be positive" do
    pet = Pet.new(petkind: "dog",name:       "dog",
                          description: "yyy",
                          image_url:   "zzz.jpg")
    pet.price = -1
    assert pet.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      pet.errors[:price]

    pet.price = 0
    assert pet.invalid?
    assert_equal ["must be greater than or equal to 0.01"], 
      pet.errors[:price]

    pet.price = 1
    assert pet.valid?
  end

  def new_pet(image_url)
    Pet.new(petkind: "dog",name:       "dog",
                description: "yyy",
                price:       1,
                image_url:   image_url)
  end
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert new_pet(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_pet(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "pet is not valid without a unique title" do
    pet = Pet.new(petkind: "dog", name:       pets(:fluffy).name,
                          description: "yyy", 
                          price:       1, 
                          image_url:   "fred.gif")

    assert pet.invalid?
    assert_equal ["has already been taken"], pet.errors[:name]
  end

  test "pet is not valid without a unique title - i18n" do
    pet = Pet.new(petkind: "Dog", name:       pets(:fluffy).name,
                          description: "yyy", 
                          price:       1, 
                          image_url:   "fred.gif")

    assert pet.invalid?
    assert_equal "has already been taken", pet.errors[:name].join('; ')
  end
  
end