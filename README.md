# Little Esty Shop

## Background and Description

"Bulk Discounts" is a solo extension of a group project that requires students to build a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices.  The extension involves implementing functionality for merchants to add bulk discounts to their items.


## Goals accomplished 
- Complete all normal user stories
- Complete extension user story discount percent logging

## Setup
This project requires Ruby 2.5.3.  
This project requires Rails 5.2.3 and later  
1. Clone this repository
```
git clone https://github.com/GrayMyers/little-esty-shop
```
2. Install dependencies
```
bundle install
```
Note: you will need to install gem install bundler if you don't have bundler  
3. Database setup
```
rails db:setup
rake csv_load:all
```
## Usage
Run the testing suite in the terminal with
```
bundle exec rspec
```
Start the server in the command line with 
```
rails server
```
Navigate [localhost:3000](http://localhost:3000)


## Technologies
- Ruby
- Ruby on Rails
### Utilities
- rspec-rails
- factory_bot_rails
- faker
- simplecov
- webmock


## Project details 
From [Turing School](https://github.com/turingschool-examples/little-esty-shop)

## Owner of solo extension
[Grayson Myers](https://github.com/GrayMyers)

## Contributors
[Gus Cunningham](https://github.com/cunninghamge)
[Grayson Myers](https://github.com/GrayMyers)
[Max Ribbans](https://github.com/ribbansmax)
[Joe Jiang](https://github.com/ninesky00)
