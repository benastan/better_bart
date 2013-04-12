# Better BART

Ruby wrapper for the [Real BART API](http://api.bart.gov/docs/overview/index.aspx).

## Installation

    gem 'bart', git: 'git://github.com/benastan/better_bart.git', branch: 'major_refactor'
    $ bundle
    
## Usage

Better BART exposes the Real BART API through a Ruby module called Bart. You can query the API by passing typed keys to this module:

    Bart[1]                     # Route 1 (Pittsburg/Bay Point - SFIA/Millbrae)
    Bart[:sfia => :pitt]        # Route 1 (Pittsburg/Bay Point - SFIA/Millbrae)
    Bart[:sfia]                 # Millbrae/SFIA station

### Routes

Routes can be accessed either through their route number, or one of the following hash representations.

    Route #     Hash Representation     Route Name
    1           {:pitt=>:sfia}          Pittsburg/Bay Point - SFIA/Millbrae
    2           {:sfia=>:pitt}          Millbrae/SFIA - Pittsburg/Bay Point 
    3           {:frmt=>:rich}          Fremont - Richmond 
    4           {:mlbr=>:rich}          Richmond - Fremont
    5           {:frmt=>:daly}          Fremont - Daly City 
    6           {:daly=>:frmt}          Daly City - Fremont 
    7           {:rich=>:mlbr}          Richmond - Daly City/Millbrae 
    8           {:mlbr=>:rich}          Millbrae/Daly City - Richmond 
    11          {:dubl=>:daly}          Dublin/Pleasanton - Daly City 
    12          {:daly=>:dubl}          Daly City - Dublin/Pleasanton

For example:

    Bart[:pitt => :sfia]        # Route 1 (Millbrae/SFIA to Pittsburg/Bay Point)
    Bart[:mlbr => :rich]        # Route 4 (Richmond - Fremont)
    
### Stations

(Coming Soon...)

### Real-time Departures

(Coming Soon...)
