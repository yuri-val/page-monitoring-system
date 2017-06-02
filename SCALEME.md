# Page monitoring system

Application can be deployed to any cloud platform and can be scaled automatically as a regular Rails application.

E.g.

## Cache
- Use gateway /reverse proxy caches to cache HTTP responses at our website.
- Use memcache to cache results that i’d otherwise pull from our database.
    
## Tend database and job handlers
Any ORM, including Rails’ ActiveRecord can generate SQL queries that cause database performance issues
   
   - Looking at slow query log after each major integration to make sure i don’t have “missing” database indices, and i haven’t written inappropriate find-all’s in Rails code.
   - Scrub database periodically for indices that are no longer being used
   - Watch the resource consumption of background and scheduled jobs
   - As base grows jobs can start to overlap, and daily log processing can start to take more than 24 hrs! Ideally, segregate jobs in a separate tier. And, as grow, look at moving to a message based job handler.
    