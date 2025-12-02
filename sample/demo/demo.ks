shot_id HelloWorld

"Kona" "Hello! Welcome to our cafe."
"Kona" "What would you like today?"

choice "Coffee" coffee_choice "Tea" tea_choice

branch coffee_choice
    "Kona" "Great choice! Our coffee is freshly brewed."
    "Kona" "Would you like it hot or iced?"
    choice "Hot" coffee_hot "Iced" coffee_iced

branch coffee_hot
    "Kona" "One hot coffee coming right up!"
    "Kona" "That will be $4.50. Please take a seat, I'll bring it to you shortly."
    end
    
branch coffee_iced
    "Kona" "Perfect for a warm day! One iced coffee coming up."
    "Kona" "That will be $5.00. I'll prepare it for you right away."
    end

branch tea_choice
    "Kona" "Excellent! We have a variety of tea leaves."
    "Kona" "Would you prefer green tea or black tea?"
    choice "Green tea" green_tea "Black tea" black_tea

branch green_tea
    "Kona" "Wonderful choice! Our green tea is imported from China."
    "Kona" "That will be $3.75. I'll steep it for the perfect amount of time."
    end
    
branch black_tea
    "Kona" "Classic choice! Our black tea has rich, bold flavors."
    "Kona" "That will be $3.50. Would you like milk or lemon with that?"
    choice "Milk" with_milk "Lemon" with_lemon "Nothing, thanks" plain_tea
    
branch with_milk
    "Kona" "Black tea with milk - a perfect combination!"
    "Kona" "I'll bring that right out to you."
    end
        
branch with_lemon
    "Kona" "Black tea with a slice of lemon - refreshing!"
    "Kona" "Coming right up!"
    end
        
branch plain_tea
    "Kona" "Simple and elegant. I'll prepare your black tea."
    "Kona" "Enjoy your tea!"
    end