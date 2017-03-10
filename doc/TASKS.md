# Next

## Client
- Improve friends with round icons instead of list for here now
- Beacon based user_locations
- Person Social media
- Person SoundCloud tracks
- Request retry
- Improvements to the launch and first run experience
- Cache images in client
- Guard view for locations services disabled

## API
- Venue exit events
- Person Social media
- Person SoundCloud tracks
- Person facets column as array
- Encrypt facebook_token / email address
- Cache images on server
- User update callback
- Create multiple facebook ID mapping
- Move person locale mapping to relation table
- Data model relate person to event via facet (DJ, performer, promoter)

## CMS
- Facebook login

## Marketing
- `hotmess` gem
- Marketing site use CORS API for "preview content"

## Other
- Investigate bloom filters to refine accuracy of venue while protecting privacy
- Cease and Desist to zYouSoft for Trademark infringement

# Done
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