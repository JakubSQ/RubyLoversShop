# RubyLoversShop

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Getting started](#getting-started)
* [Features](#features)

## General info
This repository contains the E-Commerce app, which relies on Ruby On Rails as backend framework and Bootstrap as frontend CSS library. It handles whole process of sorting or filtering products by its attributes, buying and managing them within shopping cart and finally creating orders with specific billing/shipping information. Admin's seperate layer handles functionality of adding/editing new products and managing newly created orders.
	
## Technologies
Project is created with:
* Ruby 2.7.3
* Rails 6.1.3
* Bootstrap 5.1
* PostgreSQL 2.0

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install
```

Next, migrate the database:

```
$ rails db:migrate
```

run prepared seeds:

```
$ rails db:seed
```

Finally, run the test suite to verify that everything is working correctly
```
$ rails rspec
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```

Open your browser 

```
$ http://127.0.0.1:8000/ 
```

	
## Features
- **App**
  - User/Admin authentication (Devise gem)
  - Admin and User roles
  - Pagination (Pagy gem)
  - Search engine (Ransack gem)
  - Adding products to cart (remove and edit products quantity on cart)
  - Add/edit/delete products
  - Checkout orders
  - Billing and shipping address
  - Edit/destroy orders (Admin)
  - State machine for orders (aasm gem)
  - whole app tested by rspec gem
- _**Work in progress**_
  - - Implementing loyalty programs
  - - Implementing membership options
  - - Implementing payment methods
  - - guest to be able to checkout an order


