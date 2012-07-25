# earth

Earth is a collection of data models that represent various things found here on Earth, such as pet breeds, kinds of rail travel, zip codes, and Petroleum Administration for Defense Districts.

The data that these models represent can be pulled from preconfigured authoritative sources. By default, data is pulled from [Brighter Planet's open reference data site](http://data.brighterplanet.com) using the [taps gem](http://rubygems.org/gems/taps).

## Usage

``` ruby
require 'earth'
Earth.init :automobile, :locality
ft = AutomobileFuel.first
# ...
```

`Earth.init` loads desired "data domains" as well as any supporting classes and plugins that each data model needs. A "data domain" is a grouping of related data models. For instance, all automobile-related data is in the `:automobile` domain.

See the [rdocs](http://rdoc.info/github/brighterplanet/earth) for more details on the Earth module.

### Domains

<table>
  <thead>
  <tr>
    <th>Domain</th>
    <th>Models</th>
  </tr>
  </thead>
  <tbody>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/air"><code>:air</code></a></td>
    <td>Aircraft, Airline, Airport ...</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/automobile"><code>:automobile</code></a></td>
    <td>AutomobileFuel, AutomobileMake, AutomobileModel ...</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/bus"><code>:bus</code></a></td>
    <td>BusClass, BusFuel ...</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/computation"><code>:computation</code></a></td>
    <td>ComputationCarrier, ComputationCarrierInstanceClass ...</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/diet"><code>:diet</code></a></td>
    <td>DietClass, FoodGroup ...</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/fuel"><code>:fuel</code></a></td>
    <td>Fuel, FuelPrice, GreenhouseGas ...</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/hospitality"><code>:hospitality</code></a></td>
    <td>LodgingClass, CommercialBuildingEnergyConsumptionSurveyResponse ...</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/industry"><code>:industry</code></a></td>
    <td>Industry, CbecsEnergyIntensity ...</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/locality"><code>:locality</code></a></td>
    <td>CensusDivision, Country, ZipCode ...</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/pet"><code>:pet</code></a></td>
    <td>Breed, Gender, Species ...</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/rail"><code>:rail</code></a></td>
    <td>RailClass, RailFuel, RailCompany ...</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/residence"><code>:residence</code></a></td>
    <td>Urbanity, ResidenceClass, AirConditionerUse</td>
  </tr>
  <tr>
    <td><a href="https://github.com/brighterplanet/earth/tree/master/lib/earth/shipping"><code>:shipping</code></a></td>
    <td>Carrier, ShipmentMode ...</td>
  </tr>
  </tbody>
</table>
    

### Data storage

You can store Earth data in any relational database. On your very first run, you will need to create the tables for data each model. This is done using [the `active_record_inline_schema` library](https://github.com/seamusabshere/active_record_inline_schema) if you pass the `apply_schemas` option:

``` ruby
require 'activerecord'
ActiveRecord::Base.establish_connection :adapter => ...   # Not needed if using Rails

require 'earth'
Earth.init :all, :apply_schemas => true
```

### Pulling data from data.brighterplanet.com

By default, Earth will pull data from [data.brighterplanet.com](http://data.brighterplanet.com), which continuously (and transparently) refreshes its data from authoritative sources. Simply call `#run_data_miner!` on whichever data model class you need. If there are any Earth classes that the chosen class depends on, they will be downloaded as well automatically:

``` ruby
require 'earth'
Earth.init :locality
ZipCode.run_data_miner!
```

### Pulling data from the original sources

If you'd like to bypass the [data.brighterplanet.com](http://data.brighterplanet.com) proxy and pull data directly from authoritative sources (*e.g.,* automobile data from EPA), simply require the `data\_miner` file for the desired domain:

``` ruby
require 'earth'
Earth.init :automobile

require 'earth/automobile/data_miner'
AutomobileMake.run_data_miner!
```

### Rake tasks

Earth provides handy rails tasks for creating, migrating, and data mining models whether your using it from a Rails app or a standalone Ruby app.

In your Rakefile, add:

    require 'earth/tasks'
    Earth::Tasks.new

If you're using Earth outside of Rails, all of the default `rake db:*` tasks will now be available. Within rails, certain tasks are augmented to 
help manage your Earth models using data_miner and active_record_inline_schema in addition to standard migrations.

Of note are the following tasks:

* `rake db:migrate` runs `.auto_upgrade!` on each Earth resource model.
* `rake db:seed` runs `.run_data_miner!` on each Earth resource model.

## Collaboration cycle 
Brighter Planet vigorously encourages collaborative improvement.

### You
1.  Fork the earth repository on GitHub.
1.  Write a test proving the existing implementation's inadequacy. Ensure that the test fails. Commit the test.
1.  Improve the code until your new test passes and commit your changes.
1.  Push your changes to your GitHub fork.
1.  Submit a pull request to brighterplanet.

### Brighter Planet
1.  Receive a pull request.
1.  Pull changes from forked repository.
1.  Ensure tests pass.
1.  Review changes for scientific accuracy.
1.  Merge changes to master repository and publish.
1.  Direct production environment to use new library version.
