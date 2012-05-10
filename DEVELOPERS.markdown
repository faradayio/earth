# Developer notes

## Explicitly requiring cross-domain dependencies

Currently there's very little automatic resolution of dependencies. So, let's say you have

    class ElectricMarket
      belongs_to :state
    end

You will need to require *locality* in 2 places:

    # lib/earth/electricity/electric_market.rb
    require 'earth/locality'

    # lib/earth/electricity/electric_market/data_miner.rb
    require 'earth/locality/data_miner'

If you don't, `State`'s data miner script will be empty when it is called by `ElectricMarket.run_data_miner_on_belongs_to_associations!`
