# Mingo #

Mingo is an A/B testing engine for Rails 3 apps, using MongoDB as a backend. It is still early in development, but everything covered in this README should be functional.

The name 'Mingo' is a mash-up of A/Bingo and Mongo.

## Installation ##

First, install MongoDB. Mingo was developed against v1.6, but older versions will probably work fine. If you're on Heroku or EC2, MongoHQ's free plan will probably have more than enough space for you.

Add Mingo to your Gemfile. Until a gem is released, you'll probably want to point to a specific ref:

    gem 'mingo', :git => 'git://github.com/chanks/mingo.git', :ref => '(something recent...)'

Give Mingo a collection to store your test results in. You can do this via Rails' config system:

    # config/environments/production.rb
    config.mingo.collection = Mongo::Connection.from_uri(ENV['MONGO_URI'])['database_name']['mingo_results']

Or, just use Mingo.collection= in an initializer, something like:

    if Rails.env.production?
      connection = Mongo::Connection.new "your_mongo_host", 27017, :logger => Rails.logger
      database   = connection['database_name']

      database.authenticate(ENV['MONGO_USERNAME'], ENV['MONGO_PASSWORD'])
      Mingo.collection = database['mingo_results']
    end

If you don't give Mingo a collection, it will function the same, except that the results of your tests won't be persisted anywhere. This is probably what you want in development or test mode.

Then just start writing A/B tests! No scripts or migrations are necessary.

## Usage ##

Mingo is designed to be mostly API-compatible with A/Bingo, and has the same basic features. For example, in a view:

    Our product costs <%= ab_test('price', [10, 15, 20]) %> dollars.

Each user will be randomized to see one of the three prices, and will see the same price on every request (until the session is cleared).

Later, when somebody purchases your product:

    bingo!('price')

This will mark them as having converted successfully at the price they were randomized to (but only if they previously triggered the ab_test helper).

Additionally, a given user will only be marked as a participant or a conversion in a given test once, so it won't throw off your results if somebody triggers the ab_test or bingo! helpers multiple times.

You may also convert many tests simultaneously:

    bingo!('price_on_signup_page', 'testimonial_on_signup_page', 'we_asked_them_extra_nice')

Finally, if you want to access the value that the current user would be randomized to, without actually enrolling them in the trial:

    We showed you <%= ab_choose('price', [10, 15, 20]) %> dollars for the A/B test, but we'll only charge you 8!

The ab_test, ab_choose and bingo! helpers are available in both views and controllers.

### Other Alternative Definitions ###

If you don't tell Mingo what values to use for a given test, it will return true or false instead:

    <% if ab_test('we_like_you') %>
      We like you!
    <% else %>
      We hate you!
    <% end %>

You can give Mingo a range, and it'll pick a value out of it:

    What's your favorite letter? Mine is <%= ab_test('letter', ('a'..'z')) %>!

You can give Mingo an integer, it will return another integer between 1 and the one you provided:

    I bet if we put your picture on Hot or Not, you'd score a <%= ab_test('hotness', 10)) %>!

Finally, you can give Mingo a hash with integers as values, and it will use the integers as weights:

    You'll probably see "Cat" below, but 1 out of 4 people will see "Dog" instead.
    <%= ab_test('animal', {"Cat" => 3, "Dog" => 1}) %>

### Blocks ###

If you pass the ab_test or ab_choose helpers a block, they'll yield the chosen value to it:

    <% ab_test('insult', ['java', 'php', 'mumps']) do |awful_language| %>
      Your mother uses <%= awful_language %>!
    <% end %>

### Mode ###

By default, Mingo will behave in different ways depending on the environment you're running in. Mingo has three modes:

* **:shuffle** will force Mingo to always select a random alternative on every request, regardless of what the user has previously seen. This is the default in development mode, where you'll want to easily see each of the ways your page can render.
* **:first** will force Mingo to always select the first alternative for every request. This is the default in the test environment, where it's important for your page content to be predictable. For instance, if you have a Webrat or Capybara step to click on a button with particular text, but you also want to A/B test the button's text, you can be certain that the button's text will always be the first alternative while your specs are running.
* **:standard** is the typical tracking behavior, outlined in the examples above. This is the default for production.

You can override the mode just as you would set Mingo's collection, either through Rails' config system:

    # config/environments/development.rb
    config.mingo.mode = :standard

Or on the Mingo module directly:

    Mingo.mode = :shuffle

### Rake Tasks ###

Mingo includes some rake tasks for managing test results:

* `rake mingo:results` - Outputs the current results of all your tests.
* `rake mingo:list` - Lists the names of all tests that have gathered results.
* `rake mingo:clear` - Clears all test results from Mongo.

## Cool Stuff ##

* Mingo does not read from the cache or database during normal operation, and writes are done in Mongo's non-blocking (unsafe) mode. This should keep Mingo very performant, as it doesn't spend any time waiting for I/O.

* Since Mingo doesn't rely on the database being available, it is very durable - if your MongoDB instance fails, the results collected while it is down will be lost, but Mingo's normal operation will not be interrupted (users will still be randomized, will still always see the same value, etc).

* All of the writes to Mongo are atomic, so there should be no concurrency issues. It is strongly recommended that your MongoDB server have enough RAM to hold Mingo's entire results collection in memory, though.

## Not Yet Implemented ##

* Some way to tie Mingo in with user accounts. Currently Mingo uses an integer stashed in the session to track users, which will be different if the same person logs in on multiple computers.

* Something to ignore participations/conversions by bots.
