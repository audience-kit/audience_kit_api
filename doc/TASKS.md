# Next

## Client
- **VENUE CHAT VIEW**
- Set up "Club Madagascar"
- Native like on events
- Native like on venues
- Side scroll social_links
- Prevent app from opening if build < minimum_build
- Kingfisher - Send authorization header by subclassing ImageDownloader
- BUG: Phone number when nil from server should not show
- BUG: No back on now view (NoRepro - ChrisN)
- Beacon based user_locations
- Request retry
- Improvements to the launch and first run experience
- Guard view for locations services disabled
- RSVP scope request
- RSVP buttons if scope granted
- Play tracks in app

## API
- **VENUE CHAT CHANNEL**
- Images should be authenticated
- Social links where no "handle"
- Venue exit events
- Encrypt facebook_token / email address
- Mutual friends API to determine social score for venue
- Taggable friends to buy cover - Open graph story

### Data Model
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
- Bought tickets with friends! (win)

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
- Add DJ Grind and Triston Jaxx
- Investigate bloom filters to refine accuracy of venue while protecting privacy
- Cease and Desist to zYouSoft for Trademark infringement

# Done
## Week 9
- User chekins
- API user images
- Venue message aggregate
- **REALTIME CHANNEL**
- Page / Venue "can_like" / "liked" attribute
- Improve friends with round icons instead of list for here now
- Design revision on person page
- Client shows liked when already liked
- Import user_likes
- Locations cache images
- Cache images in client
- **EFFICIENT UPDATE JOBS**
- Cache images on server
- Optimize social icons
- API: Person SoundCloud tracks
- Project venue_pages into social_links (enhance with handle, top 1 by order, hold for materialized views?)
- Client: Person Social media
- Client: Person SoundCloud tracks
- **REBUILD IMPORTERS FOR NEW DATA MODEL**
- **REBUILD API TO MATCH DATA MODEL**
- **NORMALIZE DATA MODEL**
- LocaleID should be set by /me/location
- User update callback
- Person Social media
- Person facets column as array
- Create multiple facebook ID mapping
- Move person locale mapping to relation table
- Data model relate person to event via facet (DJ, performer, promoter)
- BUG: Events in now edge in past

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