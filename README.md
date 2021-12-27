# RubyLoversShop

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Getting started](#getting-started)
* [Features](#features)

## General info
This project is simple Lorem ipsum dolor generator.
	
## Technologies
Project is created with:
* Ruby 2.7.3
* Rails 6.1.3
* Bootstrap 5.1
* PostgreSQL 2.0

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly
```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```
	
## Features
- **App**
  - User Authentication using  (BCrypt gem)
  - ADMIN and User roles 
  - Products icons saved on Google Cloud or Amazon Cloud
  - Email Account Activation
  - Users can follow other users
  - Twitter like feed mechenism for followers
  - Beautiful Search Bars
  - Beautiful Paginations
  - Users can post articles
  - Proceed products to cart
  - Make Orders
  - Edit , destroy orders (Admin)
- _**Working on it**_
  - - Implement State Machine
  - - Use more Ajax requests
  - - Implementing tickets
  - - Implementing shipping


