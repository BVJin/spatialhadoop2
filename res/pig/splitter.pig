REGISTER osmx.jar;
REGISTER pigeon.jar
REGISTER esri-geometry-api-1.0.jar;

IMPORT 'pigeon_import.pig';

all_ways = LOAD '/all_ways.tsv.gz' AS (id:long, geometry, tags:map [chararray]);

roads = FILTER all_ways BY tags#'highway' IS NOT NULL;
STORE roads INTO 'roads.tsv';

rivers = FILTER all_ways BY tags#'waterway' == 'river';
STORE rivers INTO 'rivers.tsv';

lakes = FILTER all_ways BY tags#'natural' == 'water';
STORE lakes INTO 'lakes.tsv';

cities = FILTER all_ways BY tags#'boundary' == 'administrative'
  AND (INT)tags#'admin_level' >= 4;
STORE cities INTO 'cities.tsv';

parks = FILTER all_ways BY tags#'leisure' == 'park';
STORE parks INTO 'parks.tsv';
