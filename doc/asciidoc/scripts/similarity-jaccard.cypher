// tag::function[]
RETURN algo.similarity.jaccard([1,2,3], [1,2,4,5]) AS similarity
// end::function[]

// tag::create-sample-graph[]

MERGE (french:Cuisine {name:'French'})
MERGE (italian:Cuisine {name:'Italian'})
MERGE (indian:Cuisine {name:'Indian'})
MERGE (lebanese:Cuisine {name:'Lebanese'})
MERGE (portuguese:Cuisine {name:'Portuguese'})

MERGE (zhen:Person {name: "Zhen"})
MERGE (praveena:Person {name: "Praveena"})
MERGE (michael:Person {name: "Michael"})
MERGE (arya:Person {name: "Arya"})
MERGE (karin:Person {name: "Karin"})

MERGE (praveena)-[:LIKES]->(indian)
MERGE (praveena)-[:LIKES]->(portuguese)

MERGE (zhen)-[:LIKES]->(french)
MERGE (zhen)-[:LIKES]->(indian)

MERGE (michael)-[:LIKES]->(french)
MERGE (michael)-[:LIKES]->(italian)

MERGE (arya)-[:LIKES]->(lebanese)
MERGE (arya)-[:LIKES]->(italian)
MERGE (arya)-[:LIKES]->(portuguese)

MERGE (karin)-[:LIKES]->(lebanese)
MERGE (karin)-[:LIKES]->(italian)

// end::create-sample-graph[]

// tag::stream[]
MATCH (p:Person)-[:LIKES]->(cuisine)
WITH {source:id(p), targets: collect(id(cuisine))} as userData
WITH collect(userData) as data
CALL algo.similarity.jaccard.stream(data)
YIELD source1, source2, count1, count2, intersection, similarity
RETURN algo.getNodeById(source1).name AS from, algo.getNodeById(source2).name AS to, intersection, similarity
ORDER BY similarity DESC
// end::stream[]

// tag::stream-similarity-cutoff[]
MATCH (p:Person)-[:LIKES]->(cuisine)
WITH {source:id(p), targets: collect(id(cuisine))} as userData
WITH collect(userData) as data
CALL algo.similarity.jaccard.stream(data, {similarityCutoff: 0.1})
YIELD source1, source2, count1, count2, intersection, similarity
RETURN algo.getNodeById(source1).name AS from, algo.getNodeById(source2).name AS to, intersection, similarity
ORDER BY similarity DESC
// end::stream-similarity-cutoff[]

// tag::stream-topk[]
MATCH (p:Person)-[:LIKED]->(cuisine)
WITH {source:id(p), targets: collect(id(cuisine))} as userData
WITH collect(userData) as data
CALL algo.similarity.jaccard.stream(data, {topK:3, similarityCutoff:0.5, degreeCutoff:10})
YIELD source1, source2, count1, count2, intersection, similarity
WHERE source1 < source2
WITH algo.getNodeById(source1) AS from, algo.getNodeById(source2) AS to
RETURN from.name AS from, to.name AS to, similarity
// end::stream-topk[]

// tag::write-back[]

// end::write-back[]

// tag::query[]

// end::query[]
