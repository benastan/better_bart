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
    Bart[:mlbr => :rich]        # Route 4 (Millbrae/Daly City - Richmond)
    
### Stations

Access stations using either a string or symbol as per the Real BART API's [Station Abbreviations](http://api.bart.gov/docs/overview/abbrev.aspx).

For example, to request Civic Center:

    sfia = Bart[:civc]
    => #<Bart::Station:0x007fa469a61fe8 @abbr=:civc, @result={"name"=>"Civic Center/UN Plaza", "abbr"=>"CIVC", "gtfs_latitude"=>"37.779528", "gtfs_longitude"=>"-122.413756", "address"=>"1150 Market Street", "city"=>"San Francisco", "county"=>"sanfrancisco", "state"=>"CA", "zipcode"=>"94102", "north_routes"=>{"route"=>["ROUTE 2", " ROUTE 6", " ROUTE 8", " ROUTE 12"]}, "south_routes"=>{"route"=>["ROUTE 1", " ROUTE 5", " ROUTE 7", " ROUTE 11"]}, "north_platforms"=>{"platform"=>"2"}, "south_platforms"=>{"platform"=>"1"}, "platform_info"=>"Always check destination signs and listen for departure announcements.", "intro"=>"Civic Center/UN Plaza Station is nearby some notable San Francisco destinations including including City Hall, War Memorial Opera House, Asian Art Museum, Louise M. Davies Symphony Hall, and the Main Branch of the San Francisco Public Library.", "cross_street"=>"Between: 7th & 8th St.", "food"=>"Nearby restaurant reviews from <a rel=\"external\" href=\"http://www.yelp.com/search?find_desc=Restaurant+&amp;ns=1&amp;rpp=10&amp;find_loc=1150 Market Street San Francisco, CA 94102\">yelp.com</a>", "shopping"=>"Local shopping from <a rel=\"external\" href=\"http://www.yelp.com/search?find_desc=Shopping+&amp;ns=1&amp;rpp=10&amp;find_loc=1150 Market Street San Francisco, CA 94102\">yelp.com</a>", "attraction"=>"More station area attractions from <a rel=\"external\" href=\"http://www.yelp.com/search?find_desc=+&amp;ns=1&amp;rpp=10&amp;find_loc=1150 Market Street San Francisco, CA 94102\">yelp.com</a> and <a rel=\"external\" href=\"http://www.sfgate.com/cgi-bin/article.cgi?f=/c/a/2007/05/17/NSGKNPL00L16.DTL\">sfgate.com</a>", "link"=>"http://www.bart.gov/stations/CIVC/index.aspx"}, @filename="stn.aspx", @cmd="stninfo", @name="Civic Center/UN Plaza", @latitude="37.779528", @longitude="-122.413756", @address="1150 Market Street", @city="San Francisco", @state="CA", @zipcode="94102">

Then, if you want routes to West Oakland:

    routes = civc.routes[:to => :woak]
    # Routes from Civic Center to West Oakland
    => [#<Bart::Route:0x007fa46a39de40 @cmd="routeinfo", @filename="route.aspx", @name="Millbrae/SFIA - Pittsburg/Bay Point", @abbr="SFIA-PITT", @number=2, @origin=:sfia, @destination=:pitt, @search_hash={:sfia=>:pitt}, @result={"name"=>"Millbrae/SFIA - Pittsburg/Bay Point", "abbr"=>"SFIA-PITT", "routeID"=>"ROUTE 2", "number"=>"2", "origin"=>"SFIA", "destination"=>"PITT", "direction"=>"north", "color"=>"#ffff33", "holidays"=>"1", "num_stns"=>"26", "config"=>{"station"=>["MLBR", "SFIA", "SBRN", "SSAN", "COLM", "DALY", "BALB", "GLEN", "24TH", "16TH", "CIVC", "POWL", "MONT", "EMBR", "WOAK", "12TH", "19TH", "MCAR", "ROCK", "ORIN", "LAFY", "WCRK", "PHIL", "CONC", "NCON", "PITT"]}}, @direction="north", @stations=[:mlbr, :sfia, :sbrn, :ssan, :colm, :daly, :balb, :glen, :"24th", :"16th", :civc, :powl, :mont, :embr, :woak, :"12th", :"19th", :mcar, :rock, :orin, :lafy, :wcrk, :phil, :conc, :ncon, :pitt]>, #<Bart::Route:0x007fa46a3946d8 @cmd="routeinfo", @filename="route.aspx", @name="Daly City - Dublin/Pleasanton", @abbr="DALY-DUBL", @number=12, @origin=:daly, @destination=:dubl, @search_hash={:daly=>:dubl}, @result={"name"=>"Daly City - Dublin/Pleasanton", "abbr"=>"DALY-DUBL", "routeID"=>"ROUTE 12", "number"=>"12", "origin"=>"DALY", "destination"=>"DUBL", "direction"=>"north", "color"=>"#0099cc", "holidays"=>"1", "num_stns"=>"18", "config"=>{"station"=>["DALY", "BALB", "GLEN", "24TH", "16TH", "CIVC", "POWL", "MONT", "EMBR", "WOAK", "LAKE", "FTVL", "COLS", "SANL", "BAYF", "CAST", "WDUB", "DUBL"]}}, @direction="north", @stations=[:daly, :balb, :glen, :"24th", :"16th", :civc, :powl, :mont, :embr, :woak, :lake, :ftvl, :cols, :sanl, :bayf, :cast, :wdub, :dubl]>, #<Bart::Route:0x007fa46a39ede0 @cmd="routeinfo", @filename="route.aspx", @name="Millbrae/Daly City - Richmond", @abbr="MLBR-RICH", @number=8, @origin=:mlbr, @destination=:rich, @search_hash={:mlbr=>:rich}, @result={"name"=>"Millbrae/Daly City - Richmond", "abbr"=>"MLBR-RICH", "routeID"=>"ROUTE 8", "number"=>"8", "origin"=>"MLBR", "destination"=>"RICH", "direction"=>"north", "color"=>"#ff0000", "holidays"=>"0", "num_stns"=>"23", "config"=>{"station"=>["MLBR", "SBRN", "SSAN", "COLM", "DALY", "BALB", "GLEN", "24TH", "16TH", "CIVC", "POWL", "MONT", "EMBR", "WOAK", "12TH", "19TH", "MCAR", "ASHB", "DBRK", "NBRK", "PLZA", "DELN", "RICH"]}}, @direction="north", @stations=[:mlbr, :sbrn, :ssan, :colm, :daly, :balb, :glen, :"24th", :"16th", :civc, :powl, :mont, :embr, :woak, :"12th", :"19th", :mcar, :ashb, :dbrk, :nbrk, :plza, :deln, :rich]>]
    routes.count
    => 3

Or, all routes that *include* Civic Center:

    routes = civc.routes[:woak]
    # Routes that include both Civic Center and West Oakland
    => [#<Bart::Route:0x007ff3794550c8 @cmd="routeinfo", @filename="route.aspx", @name="Millbrae/SFIA - Pittsburg/Bay Point", @abbr="SFIA-PITT", @number=2, @origin=:sfia, @destination=:pitt, @search_hash={:sfia=>:pitt}, @result={"name"=>"Millbrae/SFIA - Pittsburg/Bay Point", "abbr"=>"SFIA-PITT", "routeID"=>"ROUTE 2", "number"=>"2", "origin"=>"SFIA", "destination"=>"PITT", "direction"=>"north", "color"=>"#ffff33", "holidays"=>"1", "num_stns"=>"26", "config"=>{"station"=>["MLBR", "SFIA", "SBRN", "SSAN", "COLM", "DALY", "BALB", "GLEN", "24TH", "16TH", "CIVC", "POWL", "MONT", "EMBR", "WOAK", "12TH", "19TH", "MCAR", "ROCK", "ORIN", "LAFY", "WCRK", "PHIL", "CONC", "NCON", "PITT"]}}, @direction="north", @stations=[:mlbr, :sfia, :sbrn, :ssan, :colm, :daly, :balb, :glen, :"24th", :"16th", :civc, :powl, :mont, :embr, :woak, :"12th", :"19th", :mcar, :rock, :orin, :lafy, :wcrk, :phil, :conc, :ncon, :pitt]>, #<Bart::Route:0x007ff37944fd80 @cmd="routeinfo", @filename="route.aspx", @name="Daly City - Dublin/Pleasanton", @abbr="DALY-DUBL", @number=12, @origin=:daly, @destination=:dubl, @search_hash={:daly=>:dubl}, @result={"name"=>"Daly City - Dublin/Pleasanton", "abbr"=>"DALY-DUBL", "routeID"=>"ROUTE 12", "number"=>"12", "origin"=>"DALY", "destination"=>"DUBL", "direction"=>"north", "color"=>"#0099cc", "holidays"=>"1", "num_stns"=>"18", "config"=>{"station"=>["DALY", "BALB", "GLEN", "24TH", "16TH", "CIVC", "POWL", "MONT", "EMBR", "WOAK", "LAKE", "FTVL", "COLS", "SANL", "BAYF", "CAST", "WDUB", "DUBL"]}}, @direction="north", @stations=[:daly, :balb, :glen, :"24th", :"16th", :civc, :powl, :mont, :embr, :woak, :lake, :ftvl, :cols, :sanl, :bayf, :cast, :wdub, :dubl]>, #<Bart::Route:0x007ff3794561a8 @cmd="routeinfo", @filename="route.aspx", @name="Millbrae/Daly City - Richmond", @abbr="MLBR-RICH", @number=8, @origin=:mlbr, @destination=:rich, @search_hash={:mlbr=>:rich}, @result={"name"=>"Millbrae/Daly City - Richmond", "abbr"=>"MLBR-RICH", "routeID"=>"ROUTE 8", "number"=>"8", "origin"=>"MLBR", "destination"=>"RICH", "direction"=>"north", "color"=>"#ff0000", "holidays"=>"0", "num_stns"=>"23", "config"=>{"station"=>["MLBR", "SBRN", "SSAN", "COLM", "DALY", "BALB", "GLEN", "24TH", "16TH", "CIVC", "POWL", "MONT", "EMBR", "WOAK", "12TH", "19TH", "MCAR", "ASHB", "DBRK", "NBRK", "PLZA", "DELN", "RICH"]}}, @direction="north", @stations=[:mlbr, :sbrn, :ssan, :colm, :daly, :balb, :glen, :"24th", :"16th", :civc, :powl, :mont, :embr, :woak, :"12th", :"19th", :mcar, :ashb, :dbrk, :nbrk, :plza, :deln, :rich]>, #<Bart::Route:0x007ff379444368 @cmd="routeinfo", @filename="route.aspx", @name="Pittsburg/Bay Point - SFIA/Millbrae", @abbr="PITT-SFIA", @number=1, @origin=:pitt, @destination=:sfia, @search_hash={:pitt=>:sfia}, @result={"name"=>"Pittsburg/Bay Point - SFIA/Millbrae", "abbr"=>"PITT-SFIA", "routeID"=>"ROUTE 1", "number"=>"1", "origin"=>"PITT", "destination"=>"SFIA", "direction"=>"south", "color"=>"#ffff33", "holidays"=>"1", "num_stns"=>"26", "config"=>{"station"=>["PITT", "NCON", "CONC", "PHIL", "WCRK", "LAFY", "ORIN", "ROCK", "MCAR", "19TH", "12TH", "WOAK", "EMBR", "MONT", "POWL", "CIVC", "16TH", "24TH", "GLEN", "BALB", "DALY", "COLM", "SSAN", "SBRN", "SFIA", "MLBR"]}}, @direction="south", @stations=[:pitt, :ncon, :conc, :phil, :wcrk, :lafy, :orin, :rock, :mcar, :"19th", :"12th", :woak, :embr, :mont, :powl, :civc, :"16th", :"24th", :glen, :balb, :daly, :colm, :ssan, :sbrn, :sfia, :mlbr]>, #<Bart::Route:0x007ff37944e368 @cmd="routeinfo", @filename="route.aspx", @name="Fremont - Daly City", @abbr="FRMT-DALY", @number=5, @origin=:frmt, @destination=:daly, @search_hash={:frmt=>:daly}, @result={"name"=>"Fremont - Daly City", "abbr"=>"FRMT-DALY", "routeID"=>"ROUTE 5", "number"=>"5", "origin"=>"FRMT", "destination"=>"DALY", "direction"=>"north", "color"=>"#339933", "holidays"=>"0", "num_stns"=>"19", "config"=>{"station"=>["FRMT", "UCTY", "SHAY", "HAYW", "BAYF", "SANL", "COLS", "FTVL", "LAKE", "WOAK", "EMBR", "MONT", "POWL", "CIVC", "16TH", "24TH", "GLEN", "BALB", "DALY"]}}, @direction="north", @stations=[:frmt, :ucty, :shay, :hayw, :bayf, :sanl, :cols, :ftvl, :lake, :woak, :embr, :mont, :powl, :civc, :"16th", :"24th", :glen, :balb, :daly]>, #<Bart::Route:0x007ff3794557a8 @cmd="routeinfo", @filename="route.aspx", @name="Richmond - Daly City/Millbrae", @abbr="RICH-MLBR", @number=7, @origin=:rich, @destination=:mlbr, @search_hash={:rich=>:mlbr}, @result={"name"=>"Richmond - Daly City/Millbrae", "abbr"=>"RICH-MLBR", "routeID"=>"ROUTE 7", "number"=>"7", "origin"=>"RICH", "destination"=>"MLBR", "direction"=>"south", "color"=>"#ff0000", "holidays"=>"0", "num_stns"=>"23", "config"=>{"station"=>["RICH", "DELN", "PLZA", "NBRK", "DBRK", "ASHB", "MCAR", "19TH", "12TH", "WOAK", "EMBR", "MONT", "POWL", "CIVC", "16TH", "24TH", "GLEN", "BALB", "DALY", "COLM", "SSAN", "SBRN", "MLBR"]}}, @direction="south", @stations=[:rich, :deln, :plza, :nbrk, :dbrk, :ashb, :mcar, :"19th", :"12th", :woak, :embr, :mont, :powl, :civc, :"16th", :"24th", :glen, :balb, :daly, :colm, :ssan, :sbrn, :mlbr]>, #<Bart::Route:0x007ff37944ed90 @cmd="routeinfo", @filename="route.aspx", @name="Dublin/Pleasanton - Daly City", @abbr="DUBL-DALY", @number=11, @origin=:dubl, @destination=:daly, @search_hash={:dubl=>:daly}, @result={"name"=>"Dublin/Pleasanton - Daly City", "abbr"=>"DUBL-DALY", "routeID"=>"ROUTE 11", "number"=>"11", "origin"=>"DUBL", "destination"=>"DALY", "direction"=>"south", "color"=>"#0099cc", "holidays"=>"1", "num_stns"=>"18", "config"=>{"station"=>["DUBL", "WDUB", "CAST", "BAYF", "SANL", "COLS", "FTVL", "LAKE", "WOAK", "EMBR", "MONT", "POWL", "CIVC", "16TH", "24TH", "GLEN", "BALB", "DALY"]}}, @direction="south", @stations=[:dubl, :wdub, :cast, :bayf, :sanl, :cols, :ftvl, :lake, :woak, :embr, :mont, :powl, :civc, :"16th", :"24th", :glen, :balb, :daly]>]
    routes.count
    => 7

### Real-time Departures

(Coming Soon...)
