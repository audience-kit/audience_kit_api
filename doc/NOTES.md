# General Reference

* Venue ID Industry : b377916e-c80b-4f6e-9f20-07426a208448
* Location ID Industry : 26baec85-a55b-4676-8125-2a12f260b7f6
* NYC Venue ID : 2aed9ddc-af6a-418e-a82a-93e8c1cb45dc
* Industry Location = -73.9868899 40.7644963

# SQL Statements

## Insert Mock Location
    INSERT INTO user_locations ("created_at", "updated_at", "point", venue_id, session_id, location_id) VALUES (current_timestamp, current_timestamp, (SELECT "location" FROM locations WHERE id = '26baec85-a55b-4676-8125-2a12f260b7f6' LIMIT 1), 'b377916e-c80b-4f6e-9f20-07426a208448', '6bc98b2b-c7e5-4bd8-9740-f65449754ca5', '26baec85-a55b-4676-8125-2a12f260b7f6')
    INSERT INTO user_locations ("created_at", "updated_at", "point", venue_id, session_id, location_id) VALUES (current_timestamp, current_timestamp, (SELECT "location" FROM locations WHERE id = '26baec85-a55b-4676-8125-2a12f260b7f6' LIMIT 1), 'b377916e-c80b-4f6e-9f20-07426a208448', '39c937d5-46ac-459c-aa11-52858d2497db', '26baec85-a55b-4676-8125-2a12f260b7f6')
    INSERT INTO user_locations ("created_at", "updated_at", "point", venue_id, session_id, location_id) VALUES (current_timestamp, current_timestamp, (SELECT "location" FROM locations WHERE id = '26baec85-a55b-4676-8125-2a12f260b7f6' LIMIT 1), 'b377916e-c80b-4f6e-9f20-07426a208448', '319cbedb-7238-4825-af2a-9f30a5e510d9', '26baec85-a55b-4676-8125-2a12f260b7f6')


## Move to normalized photos (in preperation for CDN / S3)
    INSERT INTO photos (id, created_at, updated_at, source_url, hash, content, mime) SELECT uuid_generate_v4(), current_timestamp, current_timestamp, picture_url, digest(picture_image, 'sha1'), picture_image, picture_mime FROM users WHERE picture_image IS NOT NULL;
    INSERT INTO photos (id, created_at, updated_at, source_url, hash, content, mime) SELECT DISTINCT ON (digest(picture_image, 'sha1')) uuid_generate_v4(), current_timestamp, current_timestamp, picture_url, digest(picture_image, 'sha1'), picture_image, picture_mime FROM pages WHERE picture_image IS NOT NULL;
    INSERT INTO photos (id, created_at, updated_at, source_url, hash, content, mime) SELECT DISTINCT ON (digest(cover_image, 'sha1')) uuid_generate_v4(), current_timestamp, current_timestamp, cover_url, digest(cover_image, 'sha1'), cover_image, cover_mime FROM pages WHERE cover_image IS NOT NULL;
    
    UPDATE users SET photo_id = (SELECT id FROM photos WHERE hash = digest(picture_image, 'sha1'));
    UPDATE pages SET photo_id = (SELECT id FROM photos WHERE hash = digest(picture_image, 'sha1'));
    UPDATE pages SET cover_photo_id = (SELECT id FROM photos WHERE hash = digest(cover_image, 'sha1'));
