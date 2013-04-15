# Better BART

Ruby wrapper for the [Real BART API](http://api.bart.gov/docs/overview/index.aspx).

## Installation

    gem 'bart', git: 'git://github.com/benastan/better_bart.git'
    $ bundle
    
## Usage

Better BART exposes the Real BART API through a Ruby module called Bart. You can query the API by passing typed keys to this module:

    Bart[1]                     # Route 1 (Pittsburg/Bay Point - SFIA/Millbrae)
    Bart[:sfia => :pitt]        # Route 1 (Pittsburg/Bay Point - SFIA/Millbrae)
    Bart[:sfia]                 # Millbrae/SFIA station

### Routes

Access routes either through their route number, or one of the following hash representations.

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

Access stations using either a string or symbol as per the Real BART API's [Station Abbreviations](http://api.bart.gov/docs/overview/abbrev.aspx).

For example, to request San Francisco International Airport:

    sfia = Bart[:sfia]
    #<Bart::Station @abbr=:sfia, @name="San Francisco Int'l Airport", @latitude="37.616035", @longitude="-122.392612", @address="International Terminal, Level 3", @city="San Francisco Int'l Airport", @state="CA", @zipcode="94128", @routes={{:to=>:pitt}=>#<Bart::Route:0x007f960b5a3770 @name="Millbrae/SFIA - Pittsburg/Bay Point", @abbr="SFIA-PITT", @number=2, @origin=:sfia, @destination=:pitt, @search_hash={:sfia=>:pitt}>, {:from=>:pitt}=>#<Bart::Route:0x007f960b5b1168 @name="Pittsburg/Bay Point - SFIA/Millbrae", @abbr="PITT-SFIA", @number=1, @origin=:pitt, @destination=:sfia, @search_hash={:pitt=>:sfia}>}>
    
Then, if you want routes to Pittsburgh-Bay Point:

    sfia.routes[:to => :pitt]
    #<Bart::Route @name="Millbrae/SFIA - Pittsburg/Bay Point", @abbr="SFIA-PITT", @number=2, @origin=:sfia, @destination=:pitt, @search_hash={:sfia=>:pitt}>

### Real-time Departures

(Coming Soon...)
