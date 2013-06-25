This specifies how to hijack the searches on the partsregistry.

Base URL:
http://parts.igem.org/cgi/partsdb/search.cgi

Query String Format:
http://parts.igem.org/cgi/partsdb/search.cgi?<nameTextInput>=<STRING>;<nameSubmitButton>=Search

Example:
This url will do a text search for "gfp"
http://parts.igem.org/cgi/partsdb/search.cgi?searchfor1=gfp;searchfor=Search

<STRING> is the terms you want to search for (Don't put the )

Text Search:
nameTextInput = "searchfor1"
nameSubmitButton = "searchfor"

1000 Part Search
nameTextInput = "first_part"
nameSubmitButton = "search_from_to"

Subpart Search
nameTextInput = "part_list"
nameSubmitButton = "search_subparts"

Superpart Search
nameTextInput = "super_part_list"
nameSubmitButton = "search_superparts"
