# create the BookService project
# ----------------  Book Service [:8080/rest] ---------------
project-new --named bookservice --stack JAVA_EE_7

# create Author entity
jpa-new-entity --named Author
jpa-new-field --named name

# create Book entity and relationship with Author
jpa-new-entity --named Book
jpa-new-field --named title
jpa-new-field --named isbn
jpa-new-field --named author --type org.bookservice.model.Author --relationship-type Many-to-One

# create SellingPoint entity
jpa-new-entity --named SellingPoint
jpa-new-field --named name
jpa-new-field --named latitude --type Double
jpa-new-field --named longitude --type Double

# scaffold and create endpoints
scaffold-generate --provider AngularJS --generate-rest-resources --targets org.bookservice.model.*

# At this stage you can build and deploy a regular JAR
# and deploy to a Java EE7 compliant server like EAP 7 and Wildfly 10

# Since this lab is about Wildfly-Swam let's swarmify this
# Unless you which more control and create your own Main class,
# No change in your code is needed. Only Maven coordinate requires updating.

wildfly-swarm-setup
wildfly-swarm-detect-fractions --depend --build

# enable CORS
rest-new-cross-origin-resource-sharing-filter

## come up to top level so we can create a new project
cd $PWD

# ----------------  Book Store Web Front End [:8081/rest] ---------------
# Now we want to create front end swarm service to access BookService
project-new --named bookstorefrontend --stack JAVA_EE_7 --type wildfly-swarm --http-port 8081
wildfly-swarm-add-fraction --fractions undertow
mv ../bookservice/src/main/webapp/ src/main/
# manual step : change the url in the angular services to point
# to http://localhost:8080/rest/ in src/main/webapp/scripts/services

cd $PWD
# ----------------  SellingPoint Service [:8082/rest] ---------------
# create SellingPoint service
project-new --named sellingPoint --stack JAVA_EE_7 --type wildfly-swarm --http-port 8082
wildfly-swarm-add-fraction --fractions hibernate-search

# create Book entity and relationship with Author
jpa-new-entity --named Book
jpa-new-field --named isbn
java-add-annotation --annotation org.hibernate.search.annotations.Field --on-property isbn

# create Book entity and relationship with Author
jpa-new-entity --named SellingPoint
jpa-new-field --named name
java-add-annotation --annotation org.hibernate.search.annotations.Indexed
java-add-annotation --annotation org.hibernate.search.annotations.Spatial
jpa-new-field --named latitude --type Double
jpa-new-field --named longitude --type Double
java-add-annotation --annotation org.hibernate.search.annotations.Longitude --on-property longitude
java-add-annotation --annotation org.hibernate.search.annotations.Latitude --on-property latitude
jpa-new-field --named books --type org.sellingPoint.model.Book --relationship-type Many-to-Many
java-add-annotation --annotation org.hibernate.search.annotations.IndexedEmbedded --on-property books

scaffold-generate --provider AngularJS --generate-rest-resources --targets org.sellingPoint.model.*
wildfly-swarm-detect-fractions --depend --build
# enable CORS
rest-new-cross-origin-resource-sharing-filter

cd $PWD

# ----------------  KeycloakServer [:8083/auth] ---------------
# create Keycloak Server service

project-new --named keycloakserver --stack JAVA_EE_7 --type wildfly-swarm --http-port 8083 --fractions keycloak-server

build 
cd $PWD
