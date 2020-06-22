# A Journey into Realmzones on Vanilla World of Warcraft

A world of warcraft gameclient that connects to a valid realmserver, receives a list of all available realms, aswell as a realmzone field, containing information about the language/region of each realm. In Burning Crusade and later, this list was unified across all gameclients and became simply a numbered list of countries and languages that a realm can refer to. This list is was is documented on mangos docs, wowdev and several other sources. Also the source code of several implementations of `realmd`, which serves as an opensource implementation of a realmserver, does also always refer to the new enumerations.

But different to what is mentioned there, the vanilla 1.12.1 handles the values a quite different. First of all, there is no unified list, that describes the languages. Instead, there are 7 different client builds existing. Those are: 1-US, 2-Korea, 3-Europe, 4-Taiwan, 5-China, 99-Test and 101-QA. Each of these clients handles the value that are set as realmzone differently. The clients only know a certain amount of realmzones and every zone that is unknown, will not be displayed in the client at all.

## 1. US Builds (enUS)
* `1`: `United States`
* `5`: `Oceanic`

## 2. Korea Builds (koKR)
* `1`: `Korea`

## 3. Europe Builds (enGB, deDE, frFR, esES)
* `1`: `English`
* `2`: `German`
* `3`: `French`
* `5`: `Spanish`

## 4. Taiwan Realmzones (zhTW)
* `1`: `Taiwan`

## 5. China Realmzones (zhCN)
* `1`: `China`
* `2`: `CN3` (?)
* `3`: `CN7` (?)

## 99. Test Realmzones (??)
* `1`: `Test Server`
* `5`: `Oceanic`

## 101. QA Realmzones (??)
* `1`: `QA Server`

So if using a realmzone `3` will result in having the realm only visible in european- and chinese builds of the client. The european versions will display `French` where the chinese builds will display `CN7`. Using `5` the european builds will display `Spanish` and the US- and test builds will display `Oceanic` in the client realm info.

As seen above, using the value `1` does always exist, and refers the most general zone/language of that region. What was also observed during the testing is, that using a `0` instead of any other number, will always refer to the `1`. An interesting part is the gap that exists in the enumeration. So for example, the `4` is missing for the EU clients and `2-4` are missing for the US builds that were probably introduced as placeholders to split the area even further. Also, the Test-Clients seem to be a modified version as the US clients, according to the supported zone infos.

The information was probed, gathered and verified using the following gameclients: enUS, ruRU, koKR, deDE, frFR, esES, zhTW and zhCN.
There was no access to an `enGB` nor to the `test` and `QA` clients. However, a file does exist inside the enUS client (and probably others aswell) that filled the gaps in the list and gave insights about the compatible realmzones of those builds.
The file is called `Cfg_Categories.dbc` and can be found inside the `interface.mpq` inside the client:

```
long,long,str,None,None,None,None,None,None,None,flags,
1,1,"United States",,,,,,,,0x3F007E,
1,2,"Korea",,,,,,,,0x3F007E,
1,3,"English",,,,,,,,0x3F007E,
2,3,"German",,,,,,,,0x3F007E,
3,3,"French",,,,,,,,0x3F007E,
1,4,"Taiwan",,,,,,,,0x3F007E,
1,5,"China",,,,,,,,0x3F007E,
1,99,"Test Server",,,,,,,,0x3F007E,
5,1,"Oceanic",,,,,,,,0x3F007E,
1,101,"QA Server",,,,,,,,0x3F007E,
5,3,"Spanish",,,,,,,,0x3F007E,
5,99,"Oceanic",,,,,,,,0x3F007E,
2,5,"CN3",,,,,,,,0x3F007E,
3,5,"CN7",,,,,,,,0x3F007E,
```

A side note, the ruRU is a custom client, that didn't exist back then, but however is quite popular. This client is a modification of the enUS client, and by that falls into the category of the US-builds (so it only accepts `1` and `5`).
