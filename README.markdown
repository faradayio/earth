# earth

Earth is a collection of data models that represent various things found here on Earth, such as pet breeds, kinds of rail travel, zip codes, and Petroleum Administration for Defense Districts.

The data that these models represent can be pulled from http://data.brighterplanet.com

## Usage

    require 'earth'
    Earth.init :automobile, :locality
    ft = AutomobileFuelType.first
    ...

You can also run data imports via the data_miner gem.

    require 'earth'
    Earth.init :fuel
    Earth.taps_server # 'http://user:pass@data.brighterplanet.com'

    DataMiner.run :resource_names #> [FuelPrice]</tt>

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
