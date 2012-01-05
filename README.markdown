# earth

Earth is a collection of data models that represent various things found here on Earth, such as pet breeds, kinds of rail travel, zip codes, and Petroleum Administration for Defense Districts.

The data that these models represent can be pulled from http://data.brighterplanet.com

## Usage

    require 'earth'
    Earth.init :automobile, :locality
    ft = AutomobileFuel.first
    ...

`Earth.init` loads desired "data domains" as well as any supporting classes and plugins that each data model needs. A "data domain" is a grouping of related data models. For instance, all automobile-related data is in the `:automobile` domain.

### Data storage

You can store Earth data in any relational database. On your very first run, you will need to create the tables for data each model. This is done using minirecord with the `apply_schemas` option:

    require 'activerecord'
    ActiveRecord::Base.establish_connection :adapter => ...   # Not needed if using Rails

    require 'earth'
    Earth.init :all, :apply_schemas => true

### Pulling data from data.brighterplanet.com

By default, Earth will pull data from data.brighterplanet.com. Simply call `run_data_miner!` on whichever data model class you need. If there are any Earth classes that the chosen class depends on, they will be downloaded as well automatically:

    require 'earth'
    Earth.init :locality
    ZipCode.run_data_miner!

### Pulling data from the original sources

If you'd like to pull data directly from the source, e.g. Automobile data from EPA's sources, simply require the data\_miner file for the desired domain:

    require 'earth'
    Earth.init :automobile

    require 'earth/automobile/data_miner'
    AutomobileMake.run_data_miner!

## Collaboration cycle 
Brighter Planet vigorously encourages collaborative improvement of its emitter libraries. Collaboration requires a (free) GitHub account.

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
1.  Direct production environment to use new emitter version.
