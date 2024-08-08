[Readme reference] This project, Restaurant Menu, is part of the Aenzbi suite. For more details, refer to the README.md file.

/*
 * aenzbi - Business Management Software
 * 
 * Copyright (c) 2024 Ally Elvis Nzeyimana
 * 
 * This software is licensed under the MIT License. See the LICENSE file for details.
 */

#!/bin/bash

# Set up directories and files
mkdir -p restaurant_menu/{css,js,images}

# Create HTML file
cat <<EOF > restaurant_menu/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Menu</title>
    <link rel="stylesheet" href="css/styles.css">
    <script src="https://js.stripe.com/v3/"></script>
</head>
<body>
    <div id="restaurant-menu">
        <h1>Our Menu</h1>
        <div class="menu-category">
            <h2>Appetizers</h2>
            <div class="menu-item">
                <img src="images/appetizer1.jpg" alt="Appetizer 1">
                <div class="menu-item-details">
                    <h3>Appetizer 1</h3>
                    <p>Description of Appetizer 1.</p>
                    <span class="price">$10.00</span>
                    <button class="add-to-cart">Add to Cart</button>
                </div>
            </div>
            <!-- More menu items here -->
        </div>
    </div>

    <div id="cart">
        <h2>Your Cart</h2>
        <div id="cart-items"></div>
        <div id="cart-total">Total: $<span id="total-amount">0.00</span></div>
        <button id="checkout-button">Checkout</button>
    </div>

    <script src="js/script.js"></script>
</body>
</html>
EOF

# Create CSS file
cat <<EOF > restaurant_menu/css/styles.css
#restaurant-menu {
    width: 80%;
    margin: 0 auto;
    font-family: Arial, sans-serif;
}
.menu-category {
    margin-bottom: 2rem;
}
.menu-item {
    display: flex;
    align-items: center;
    margin-bottom: 1rem;
}
.menu-item img {
    width: 100px;
    height: 100px;
    margin-right: 1rem;
    border-radius: 8px;
}
.menu-item-details {
    flex: 1;
}
#cart {
    width: 80%;
    margin: 2rem auto;
    padding: 1rem;
    border: 1px solid #ddd;
    background-color: #f9f9f9;
}
#cart-total {
    font-weight: bold;
    margin-bottom: 1rem;
}
#checkout-button {
    padding: 0.5rem 1rem;
    background-color: #4CAF50;
    color: #fff;
    border: none;
    cursor: pointer;
}
EOF

# Create JavaScript file
cat <<EOF > restaurant_menu/js/script.js
document.addEventListener('DOMContentLoaded', () => {
    const cartItems = [];
    const cartContainer = document.getElementById('cart-items');
    const totalAmountElement = document.getElementById('total-amount');
    const addToCartButtons = document.querySelectorAll('.add-to-cart');

    addToCartButtons.forEach(button => {
        button.addEventListener('click', (e) => {
            const menuItem = e.target.closest('.menu-item');
            const itemName = menuItem.querySelector('h3').textContent;
            const itemPrice = parseFloat(menuItem.querySelector('.price').textContent.replace('$', ''));

            const cartItem = { name: itemName, price: itemPrice };
            cartItems.push(cartItem);
            updateCart();
        });
    });

    function updateCart() {
        cartContainer.innerHTML = '';
        let total = 0;

        cartItems.forEach(item => {
            total += item.price;
            const cartItemElement = \`
                <div class="cart-item">
                    <span>\${item.name}</span>
                    <span>$\${item.price.toFixed(2)}</span>
                </div>
            \`;
            cartContainer.innerHTML += cartItemElement;
        });

        totalAmountElement.textContent = total.toFixed(2);
    }

    document.getElementById('checkout-button').addEventListener('click', () => {
        if (cartItems.length > 0) {
            proceedToPayment(totalAmountElement.textContent);
        } else {
            alert("Your cart is empty!");
        }
    });

    function proceedToPayment(total) {
        const stripe = Stripe('your-publishable-key-here');

        fetch('/create-checkout-session', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                items: cartItems.map(item => ({
                    name: item.name,
                    amount: Math.round(item.price * 100),
                    quantity: 1,
                })),
            }),
        })
        .then(response => response.json())
        .then(session => {
            return stripe.redirectToCheckout({ sessionId: session.id });
        })
        .then(result => {
            if (result.error) {
                alert(result.error.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });
    }
});
EOF

# Create a simple image placeholder
echo "Creating sample image..."
convert -size 100x100 xc:grey restaurant_menu/images/appetizer1.jpg

# Start a simple HTTP server
cd restaurant_menu
echo "Starting server on http://localhost:8000..."
python3 -m http.server 8000