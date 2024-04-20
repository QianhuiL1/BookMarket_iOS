# Bookstore - A Simple iOS APP demo

This repository contains the source code for a comprehensive Bookstore App developed as an experimental project. The app features a user-friendly interface for browsing books, managing a shopping cart, and handling user authentication and orders.

## Features

- **User Authentication**: Secure login and registration system with feedback on authentication errors. User credentials are verified against a database, and successful logins direct users to the book list.
- **Book Browsing**: Books are displayed in a TableView, categorized by genre, with each entry showing the book's cover, title, and price.
- **Detailed Book Views**: Detailed pages for each book that include high-resolution cover images, pricing, author details, and a description. Users can add books to their shopping cart from this view.
- **Shopping Cart**: Users can view their cart, select books for purchase or deletion, and refresh the cart contents using a pull-down gesture.
- **Order Processing**: A streamlined checkout process with a confirmation step for purchases, followed by an order success page. The cart items are transferred to a historical order list upon purchase.
- **Order History**: Historical purchases are viewable in a list showing the first book image, title, and price of each order. Detailed order views are accessible by tapping on an order entry.

## Development Environment

- **Platform**: macOS 12.2.1
- **IDE**: Xcode 13.2.1
- **Language**: Swift 5.5.2
- **Testing**: iPhone 11 Simulator

## Modules

### Login and Registration
- Animations using UIView's `animate` method.
- User sessions managed with UserDefaults for persisting login states.

### Book List
- Data fetched from a `book` database and displayed in categorized lists.
- Delegation pattern used for transferring items to the shopping cart.

### Shopping Cart
- Cart management with options to edit selections and finalize purchases.
- UIRefreshControl for dynamic content updates.

### Order History
- Display and management of past orders with detailed views accessible for each order.
