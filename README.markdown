# Count #

Count makes A/B testing simple and easy for Ruby applications. It uses MongoDB as a backend.

Count is tested on Ruby 1.8.7 and 1.9.2, but should work anywhere the Mongo gem does. The Mongo gem is also the only dependency.

## Features ##

* Performance: Count does not need to read from the database or cache during normal operation, and writes are done in Mongo's asynchronous mode. As a result, Count never holds your app up to wait for I/O.

* Durability: Since Count doesn't rely on the database being available, your application will not be impaired if your MongoDB instance fails or becomes slow. The test results collected during that time may be lost, but users will still be randomized properly, will still always see the same value, and so on.

* Concurrency: All of the writes to Mongo are atomic and idempotent, so there should be no issues with high-concurrency applications.

* Rails 3 Integration: Count includes a Railtie for seamless and easy integration with Rails 3 apps.

## Installation ##

Before anything else, you'll want to install [MongoDB](http://www.mongodb.org/downloads). Count was developed against v1.6, but older versions will probably work fine. If your production app is hosted on EC2 (including Heroku or Engine Yard), the free plans at [MongoLab](https://mongolab.com) or [MongoHQ](https://mongohq.com) will probably have more than enough space for you. It's strongly recommended that your MongoDB instance have enough RAM to hold Count's entire results collection in memory, but for most applications that won't be very much.

Add Count to your Gemfile. The BSON C extension gem is optional, but a good idea.

    gem 'count'
    gem 'bson_ext', '~> 1.3'

Next, you need to give Count a MongoDB collection it can use to store your test results in:

    database = Mongo::Connection.new('your_mongo_host', 27017).db('database_name')

    database.authenticate(ENV['MONGO_USERNAME'], ENV['MONGO_PASSWORD'])

    Count.collection = database.collection('count_results')

If you're using Rails, the above could go in an initializer. Or you could use the config system in Rails 3:

    # config/environments/production.rb
    config.count.collection = Mongo::Connection.from_uri(ENV['MONGO_URI'])['database_name']['count_results']

If you don't give Count a collection, it will function the same, except that the results of your tests won't be persisted anywhere. In the development or test environments this is probably what you want anyway.

## Helpers and Writing Tests ##

Count is used via three simple methods. If you're using Rails 3, they're already available in your controllers and views. If you want them available in one of your models, or if you're not using Rails 3, you'll need to include Count::Helpers wherever you want to use them, and define a count_id method there also (more on that later).

Count is mostly API-compatible with the A/Bingo gem. For example, you might put in a view:

    Our product costs <%= ab_test(:price, ["$10.00", "$15.00", "$20.00"]) %> per month.

Each user will be randomized to see one of the three prices. Later, when somebody purchases your product, call bingo!

    bingo!(:price)

This will mark them as having converted successfully at the price they were randomized to. You may also convert many tests simultaneously:

    bingo!(:price_on_signup_page, :testimonial_on_signup_page, :we_asked_them_extra_nice)

Finally, if you want to access the value that the current user would be randomized to, without actually triggering MongoDB to remember them:

    We showed you <%= ab_choose(:price, ["$10.00", "$15.00", "$20.00"]) %> dollars for the A/B test, but we'll only charge you 8!

When using Count:

* A given user will see the same price on every request.
* No matter how many times a given user triggers the ab_test or bingo! helpers, they'll only be marked as being a participant or conversion in that particular trial once.
* A given user will be marked as a conversion only if they previously triggered the ab_test helper.

### Other Helper Options ###

If you don't tell Count what values to use for a given test, it will return true or false instead:

    <% if ab_test(:we_like_you) %>
      We like you!
    <% else %>
      We hate you!
    <% end %>

You can give Count a range, and it'll pick a value out of it:

    What's your favorite letter? Mine is <%= ab_test(:letter, ('A'..'Z')) %>!

You can give Count an integer, and it'll return another integer between 1 and the one you provided:

    I bet if we put your picture on Hot or Not, you'd score a <%= ab_test(:hotness, 10)) %>!

You can give Count a hash with integers as values, and it will use the integers as probability weights:

    You'll probably see "Cat" below, but 1 out of 10 people will see "Dog" instead.
    <%= ab_test(:animal, {"Cat" => 9, "Dog" => 1}) %>

Finally, if you pass the ab_test or ab_choose helpers a block, they'll yield the chosen value to it:

    <% ab_test(:insult, ['Java', 'PHP', 'MUMPS']) do |awful_language| %>
      Your mother uses <%= awful_language %>!
    <% end %>

### count_id ###

In order to determine what the ab_test and ab_choose helpers should return, and to track trial/conversion status, Count needs to be able to uniquely identify the current user. In Rails 3 apps, by default, Count will insert a random integer into the session and access it when necessary. This will probably be fine for testing short-term conversions like landing pages, but if the same person logs in to your app in different browsers, or if you clear their session, the values returned by ab_test and ab_choose for that user will start to become erratic, and the conversion results will be thrown off.

You can override this behavior by defining a 'count_id' method, which Count will call when it needs to determine who a user is. For example, you could return the user's database id if they're logged in, and fall back to Count's default behavior if they're not:

    class ApplicationController < ActionController::Base
      def count_id
        if current_user
          current_user.id
        else
          super
        end
      end
    end

If you're not using Rails 3, or if you want to use Count's helpers in a model, you'll need to define a #count_id method wherever you include Count::Helpers. For example:

    class User
      include Count::Helpers

      def initialize(id)
        @id = id
      end

      def buy_something!
        bingo! :sucker
      end

      private

      def count_id
        @id
      end
    end

Count will often access 'count_id' several times over the course of a request, so if it's an expensive operation (e.g. a database call) it would be a good idea to memoize it.

### Mode ###

If you're using Rails, Count will behave in different ways depending on the environment you're running in. Count has three modes:

* **:standard** is the typical tracking behavior, outlined in the examples above. This is the default in production.
* **:shuffle** will force Count to always select a random alternative on every request, regardless of what the user has previously seen. This is the default in development, where you'll want to easily see the different ways your page can render.
* **:first** will force Count to always select the first alternative for every request. This is the default in the test environment, where it's important for your page content to be predictable. For instance, if you have a Webrat or Capybara step to click on a button with particular text, but you also want to A/B test the button's text, you can be certain that the button's text will always be the first alternative while your specs are running.

You can override the mode just as you would set Count's collection, either through Rails' config system:

    # config/environments/development.rb
    config.count.mode = :standard

Or on the Count module directly:

    Count.mode = :shuffle

If you're not using Rails, Count will stick to :standard mode unless you change it.

### Rake Tasks ###

Count includes some rake tasks for managing test results:

* `rake count:results` - Outputs the current results of all your tests.
* `rake count:list` - Lists the names of all tests that have gathered results.
* `rake count:clear` - Clears all test results from Mongo.
* `rake count:index` - Adds an index that may help the database if your results collection is large. Probably unnecessary for most apps.

## To Do ##

* Figure out how to best ignore participations/conversions by bots.

* Figure out how to best test Count under other versions of Ruby. Railties is a development dependency, and it requires 1.8.7 or 1.9.2 so it's hard to run specs under other versions, even though Count's codebase is pretty small and simple and should work fine.
