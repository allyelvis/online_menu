# Restaurant Menu - Aenzbi

## Overview
The **Restaurant Menu** project is a part of the Aenzbi suite, designed to offer a digital menu for restaurants. Customers can view the menu, place orders, and make payments online through an integrated payment gateway.

## Features
- Digital restaurant menu accessible online
- Add items to the cart and place orders
- Integrated payment processing using Stripe
- Easy-to-customize menu layout

## Installation
To set up the project locally, follow these steps:
1. Run the provided Bash script `setup_menu.sh` to set up the directory structure and start a local HTTP server.
2. Install Node.js and the required dependencies for the Stripe server using:
   ```
   npm install express stripe
   ```
3. Start the Stripe server:
   ```
   node server.js
   ```

## Usage
- Access the menu at `http://localhost:8000`.
- Add items to the cart and proceed to checkout.
- The Stripe server handles payment processing at `http://localhost:3000`.

## License
This software is licensed under the MIT License. See the LICENSE file for details.
