Pet.delete_all
Pet.create(
	petkind: 'Dog',
	name: 'Oliver',
	description: 
    %{
        Oliver is a very friendly boxer puppy of 5 months. He loves children and is
		already <i>mostly</i> housebroken. He is a fantastic dog.
    },
  image_url:   'oliver.jpg',    
  price: 75.00
)
Pet.create(
	petkind: 'Dog',
	name: 'Zues',
	description: 
    %{
        Zues was found in the forest after he ran away. He thinks he is a deer.
    },
  image_url:   'zues.JPG',    
  price: 150.00
)
Pet.create(
	petkind: 'Bengal Tiger',
	name: 'William',
	description: 
    %{
        William's previous owner was probably eaten by a bear or something that was not William. William is too adorable to eat you!...
    },
  image_url:   'william.jpg',    
  price: 7500.00
)
Pet.create(
	petkind: 'Sea Monster',
	name: 'Jenny',
	description: 
    %{
        What a horrible idea for a pet. Please don't buy Jenny. You <b style="color:#FF0000"><i>will</b></i> regret it.
    },
  image_url:   'jenny.jpg',    
  price: 5.00
)