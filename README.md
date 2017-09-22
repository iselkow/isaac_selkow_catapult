# README

I answered the basic solution. I want to be fully honest- I spent about 3 hours on this exercise, not 2.
I hope that this is okay- I wanted to reach a full solution.

I had to make a few key decisions in the process.

1. When returning nested objects (for example, a breed's tags), I elected to include the tag's root and object
rather than just the tag's name. I felt that this would be more useful for a user who needs to access the structured
data.

2. In order to speed up the stats pages I implemented a cache_counter on the BreedTagRecord table. This should prevent us
from having to query the database for a count on each individual breed or tag.

3. I hope that the SQL used in the destroy_orphan_tags is sufficiently performant. It allows us to get all of the offending id's
in just 3 queries. The third query uses a delete_all rather than a destroy_all which wraps each delete in an ActiveRecord transaction.
I'm comfortable with the delete_all because any BreedTagRecord that would be destroyed on a dependent: :destroy is already being
destroyed by the Breed's dependent: :destroy.

4. I elected NOT to display all associated breeds when displaying tags. This was not in the specs and I was already tight on time. With more
time I think this might be worth doing. In a real world scenario this is something that I'd present to the client as an idea while explaining
the associated resource tradeoff.

5. Given more time, I think the next feature to build would be authentication.
