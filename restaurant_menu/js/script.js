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
            const cartItemElement = `
                <div class="cart-item">
                    <span>${item.name}</span>
                    <span>$${item.price.toFixed(2)}</span>
                </div>
            `;
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
