Extract human-readable division descriptions from Public Whip.

# Background

PublicWhip.org.uk allows users to provide human readable descriptions of
divisions. As part of this there are two magic fields that provide a
one-line summary of how any given MP voted, based on a Yes or No vote.

See, for example, 
[this division](http://www.publicwhip.org.uk/division.php?date=2012-03-13&number=489&mpn=Julian_Huppert&mpc=Cambridge&house=commons),
which says that "Julian Huppert MP, Cambridge voted against proposed NHS
reforms including giving more power to GPs to commission services,
strengthening the Care Quality Commission, and cutting admin costs for
example by abolishing Primary Care Trusts."

Rather than scraping those, which is quite tricky as it requires
slightly complex calculations to work out which MPs pages to fetch for
each division, we can get them from the 
[raw database dumps](http://www.publicwhip.org.uk/project/data.php)
instead. 

# Steps

1) Download the current 
[dynamic table dump](http://www.publicwhip.org.uk/data/pw_dynamic_tables.sql.bz2)

2) `bunzip` it, and load it into a `tempdb` mysql database (you can call
this database whatever you like, as long as you change the dump line
too)

3) `mysqldump --no-create-info --xml tempdb pw_dyn_wiki_motion > dyn_divisions.xml`

(You may need to provide -u and -p options too if you require a username
and password for your database)

4) `ruby parse_divisions.rb dyn_divisions.xml > pw_divisions.json`


