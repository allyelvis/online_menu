[Readme reference] This project, Restaurant Menu, is part of the Aenzbi suite. For more details, refer to the README.md file.

/*
 * aenzbi - Business Management Software
 * 
 * Copyright (c) 2024 Ally Elvis Nzeyimana
 * 
 * This software is licensed under the MIT License. See the LICENSE file for details.
 */

// Save this as server.js

const express = require('express');
const stripe = require('stripe')('your-secret-key-here');
const app = express();
app.use(express.static('restaurant_menu'));
app.use(express.json());

app.post('/create-checkout-session', async (req, res) => {
    const session = await stripe.checkout.sessions.create({
        payment_method_types: ['card'],
        line_items: req.body.items,
        mode: 'payment',
        success_url: 'http://localhost:8000/success.html',
        cancel_url: 'http://localhost:8000/cancel.html',
    });
    res.json({ id: session.id });
});

app.listen(3000, () => {
    console.log('Stripe server running on http://localhost:3000');
});