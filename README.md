# Nasdaq Scraper

This is an experiment in scraping quotes from Nasdaq.com.

It touches Quotes, History, Summaries and Charts.

## Testing

    bundle install
    bundle exec rake test

## Example Usage

    >> Nasdaq::Quote.for("MO")
    => #<Nasdaq::Quote consolidated_shares=100 high=40.43 low=40.43 market_close_time="16:0" market_status="C" previous_close=39.93 price=40.43 refresh_time=20000 server_time="4/29/2014 9:10:15 AM" symbol="MO" tot_vol=6 trade_date="4/29/2014 9:10:15 AM">

    >> Nasdaq::History.for("MO")
    => #<Nasdaq::History close=39.93 date=#<Date: 2014-04-28 ((2456776j,0s,0n),+0s,2299161j)> high=40.15 low=39.22 open=39.22 volume=13563000>
       #<Nasdaq::History close=39.11 date=#<Date: 2014-04-25 ((2456773j,0s,0n),+0s,2299161j)> high=39.11 low=38.2 open=38.4 volume=8560673>
       #<Nasdaq::History close=38.4 date=#<Date: 2014-04-24 ((2456772j,0s,0n),+0s,2299161j)> high=38.8 low=38.07 open=38.34 volume=8667609>
       ...
       #<Nasdaq::History close=37.12 date=#<Date: 2014-03-28 ((2456745j,0s,0n),+0s,2299161j)> high=37.36 low=36.97 open=37.31 volume=5250508>

    >> Nasdaq::Summary.for("MO")
    => #<Nasdaq::Summary shares_outstanding=2034844000 stock_exchange="NYSE" symbol="MO">

## Quotes

To get started, let's check the price for Altria (MO) because everyone loves smoking, right?

### Query

    curl -i "http://www.nasdaq.com/quote.dll?page=dynamic&mode=data&symbol=MO&random=0.7634591432288283"

### Response

    HTTP/1.1 200 ok
    Content-Length: 113
    Content-Type: text/plain
    Server: Microsoft-IIS/7.5
    Date: Thu, 18 Aug 2011 06:01:43 GMT
    Connection: close

    *MO|26|0.32|1.25%|13,603,764|up|Y|$&nbsp;26.17|$&nbsp;25.79|MO|Dec. 31, 1969|N/A|N/A|N|NYSE|N|Altria Group|

What fields are returned in the data?

    *MO - Symbol
    26 - Price in $US. The price here is $26.00 even
    0.32 - Change in $US, from
    1.25% - Change in %
    13,603,764 - Volume of shares traded
    up - Direction of movement. Values (up, down)
    Y - Unknown. Values (Y, A, N)
    $&nbsp;26.17 - Day high. Unescaped value would be "$ 26.17"
    $&nbsp;25.79 - Day low. Unescaped value would be "$ 25.79"
    MO - Symbol
    Dec. 31, 1969 - Unknown
    N/A - Unknown
    N/A - Unknown
    N - Unknown
    NYSE - Stock exchange
    N - Unknown
    Altria Group - Company name

OK, so after we smoke that tasty (oh so tasty!) tobacco, it's time for a Coke :)

    $ curl -i "http://www.nasdaq.com/quote.dll?page=dynamic&mode=data&symbol=KO&random=0.7634591432288283"
    HTTP/1.1 200 ok
    Content-Length: 127
    Content-Type: text/plain
    Server: Microsoft-IIS/7.5
    Date: Thu, 18 Aug 2011 06:01:57 GMT
    Connection: close

    *KO|69.28|1.11|1.63%|11,587,911|up|Y|$&nbsp;69.35|$&nbsp;68.16|KO|Dec. 31, 1969|N/A|N/A|N|NYSE|N|Coca-Cola Company (The)|

## Price History

Lets find the price history for KO.

See the "5120" in the URL? The "5" means nothing to us, but the 120 is the
number of months of data to return. 120 months is 10 years. But you can
specify longer in the URL. Nasdaq only makes prices back to 2 Jan 1990
though.

    http://charting.nasdaq.com/ext/charts.dll?2-1-14-0-0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0|0,0,0,0,0-5120-03NA000000KO-&SF:4|5-WD=539-HT=395--XXCL-

All of the pipe delimited "0,0,0,0,0" sets can be eliminated with no change
to the output. Sweet. (Ooops! They cannot be removed)

Here is 3 months of Altria price data

    http://charting.nasdaq.com/ext/charts.dll?2-1-14-0-0,0,0,0,00,0,0,0,0-5003-03NA000000MO-&SF:4|5-WD=539-HT=395--XCL-

## Realtime Quotes

Quote for KO

### Request

    GET http://www.nasdaq.com/aspx/NLS/NLSHandler.ashx?msg=Last&Symbol=KO&QESymbol=KO

### Response

    <DocumentElement>
      <Last>
        <totVol>1711</totVol>
        <high>67.8200</high>
        <low>67.2800</low>
        <Price>67.8200</Price>
        <ConsolidatedShares>2715</ConsolidatedShares>
        <ServerTime>9/23/2011 8:06:41 AM</ServerTime>
        <RefreshTime>35000</RefreshTime>
        <MarketStatus>C</MarketStatus>
        <MarketCloseTime>16:0</MarketCloseTime>
        <previousclose>67.82</previousclose>
        <tradedate>9/23/2011 8:06:41 AM</tradedate>
      </Last>
    </DocumentElement>

## Summary Data

Get the summary data html page for Altria (MO)

    http://www.nasdaq.com/symbol/mo


## Charts

The charts are rendered by URL's like this...

    http://charting.nasdaq.com/ext/charts.dll?2-1-14-0-0-51-03NA000000KO-&SF:1|8|5-SH:8=20-WD=539-HT=395-

The SF:X parameter changes the type of chart.

    SF:1  | Mountain
    SF:4  | OHLC
    SF:6  | Candlestick
    SF:7  | Line
    SF:43 | Bar

Other parameters

    WD    | Width
    HT    | Height

Lower Studies

The "5-SH" means that volume is rendered in the "lower studies" section at
the bottom of the chart.

"8=20"  | Render the 20 day moving average
"8=50"  | Render the 50 day moving average

50 day moving average

    http://charting.nasdaq.com/ext/charts.dll?2-1-14-0-0-51-03NA000000KO-&SF:1|8|5-SH:8=50-WD=539-HT=395-

MACD

The parameters "15=12,26,9" causes the lower studies section to show
the MACD.

Note that parameters are pipe delimited in the url in some places.

    http://charting.nasdaq.com/ext/charts.dll?2-1-14-0-0-51-03NA000000KO-&SF:1|8|15-SH:8=20|15=12,26,9-WD=539-HT=395-

The "27=10" causes the rendering of the RSI (Relative Strength Index)

    http://charting.nasdaq.com/ext/charts.dll?2-1-14-0-0-51-03NA000000KO-&SF:1|8|27-SH:8=20|27=10-WD=539-HT=395-

### Examples

#### Mountain

    curl "http://charting.nasdaq.com/ext/charts.dll?2-1-14-0-0-51-03NA000000KO-&SF:1|8|5-SH:8=20-WD=539-HT=395-" > ko-mountain-1.gif

#### OHLC

    curl "http://charting.nasdaq.com/ext/charts.dll?2-1-14-0-0-51-03NA000000KO-&SF:4|8|5-SH:8=20-WD=539-HT=395-" > ko-ohlc-1.gif

#### Candlestick

    curl "http://charting.nasdaq.com/ext/charts.dll?2-1-14-0-0-51-03NA000000KO-&SF:6|8|5-SH:8=20-WD=539-HT=395-" > ko-candlestick-1.gif

#### Line

    curl "http://charting.nasdaq.com/ext/charts.dll?2-1-14-0-0-51-03NA000000KO-&SF:7|8|5-SH:8=20-WD=539-HT=395-" > ko-line-1.gif

#### Bar

    curl "http://charting.nasdaq.com/ext/charts.dll?2-1-14-0-0-51-03NA000000KO-&SF:43|8|5-SH:8=20-WD=539-HT=395-" > ko-bar-1.gif

## RSS Feeds

For example, this is the Altria RSS Feed on Nasdaq.

    http://articlefeeds.nasdaq.com/nasdaq/symbols?symbol=MO


## Stock Exchange Names

NASDAQ-GM is short for NASDAQ Global Market.

NASDAQ-GS is short for NASDAQ Global Select Market.

These are two different market tiers, both run by the National Association of Security Dealers (NASD).

Stocks traded in either tier (the NASDAQ-GM tier and the NASDAQ-GS tier) count as NASDAQ stocks.


# License

The MIT License (MIT)

Copyright (c) 2014 Scott Barr

See [LICENSE.md](LICENSE.md)
