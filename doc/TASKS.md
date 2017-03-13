# Next

## Client
- BUG: No back on now view (NoRepro - ChrisN)
- Improve friends with round icons instead of list for here now
- Beacon based user_locations
- Person Social media
- Person SoundCloud tracks
- Request retry
- Improvements to the launch and first run experience
- Cache images in client
- Guard view for locations services disabled
- RSVP scope request
- RSVP buttons if scope granted
- Page / Venue "can_like" / "liked" attribute

## API
- **REBUILD IMPORTERS FOR NEW DATA MODEL**
- BUG: Phone number not shown
- BUG: Events in now edge in past
- Project venue_pages into social_links (enhance with handle, top 1 by order, hold for materialized views?)
- Venue exit events
- Person SoundCloud tracks
- Encrypt facebook_token / email address
- Cache images on server
- Mutual friends API to determine social score for venue

### Data Model
- `add_table :photo...`
- `add_table :track...`
- Recurring events (not facebook linked)
- Venues lacking pages:
  - The Hanger
  - Boiler Room
  - Adonis Lounge
  - The Out Hotel
  - Phoenix Bar
  - Ty's Bar NYC
  - 11:11 Eleven Eleven
  - Bill's Gay Nineties
  - Evolve


### Facebook Graph Objects (ugh, please don't make me)
- Check in via app?  (consent only)
- Attended / attending event?

### API Privacy
- Sunset policy on records
- Maximum tolerance on GPS coordinates recorded
- Extended envelope for tracked areas to record
- Gaussian field / bloom filter
- Course location to detect new venues (long term as the bloom filter needs to be online)
- Does time need to be recorded for above or just done by cohort (sliding window?)

## CMS
- Facebook login

## Marketing
- BUG: Some sign-ups dont contain email
- `hotmess` gem
- Marketing site use CORS API for "preview content"

## Other
- Investigate bloom filters to refine accuracy of venue while protecting privacy
- Cease and Desist to zYouSoft for Trademark infringement

# Done
## Week 9
- **REBUILD API TO MATCH DATA MODEL**
- **NORMALIZE DATA MODEL**
- LocaleID should be set by /me/location
- User update callback
- Person Social media
- Person facets column as array
- Create multiple facebook ID mapping
- Move person locale mapping to relation table
- Data model relate person to event via facet (DJ, performer, promoter)

## Week 8
- Improve event page
- Beta prompt if no email
- Track app version and phone model
- `hot_mess_models` gem
- Happening now guard view
- Venue Map (envelope and points)
- Improve user_locations with geometry and tolerance
- CMS
  - Import person
  - Import venue
  - Edit person
  - Edit venue
 ## Week 7
- Support people (use 11:11 as first example)
  - Promoters
  - Drag Performers
  - DJs
  - Implement in app
- Restrict people to locale
- People list link to facebook page
- Cache locale to last
- TLS certificate for marketing site
- Launching view
- Locale load before dismiss login
- Dismiss login view correctly
- Settings view must show Facebook user
  - Had this right in old application
- Improve people list with photo
- Happening now view
- Marketing site beta sign-up
- Screen-shots for AppStore
- here now
- user_locations
- JWT token has admin privilege 
- People list populates
  - Events from person pages also show in Events
- Improve venue view
- Person view
- Event view
- Improve venue list
- Place user location events onto Kafka bus