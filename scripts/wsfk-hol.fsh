# create the BookService project
# ----------------  Book Service [:8080/rest] ---------------
project-new --named bookservice --stack JAVA_EE_7

# add the boostrap data
cp ../bookservice_assets/import.sql src/main/resources
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
rest-generate-endpoints-from-entities --targets org.bookservice.model.*
scaffold-generate --provider AngularJS --targets org.bookservice.model.*

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
cd ~~
cd ..

# ----------------  Book Store Web Front End [:8081/rest] ---------------
# Now we want to create front end swarm service to access BookService
project-new --named bookstorefrontend --stack JAVA_EE_7 --type wildfly-swarm --http-port 8081
wildfly-swarm-add-fraction --fractions undertow
mv ../bookservice/src/main/webapp/ src/main/

# Keep empty src/main/webapp/WEB-INF
mkdir ../bookservice/src/main/webapp
mkdir ../bookservice/src/main/webapp/WEB-INF

cd ~~
cd ..

# ----------------  SellingPoint Service [:8082/rest] ---------------
# create SellingPoint service
project-new --named sellingPoint --stack JAVA_EE_7 --type wildfly-swarm --http-port 8082
wildfly-swarm-add-fraction --fractions hibernate-search
cp ../sellingpoint_assets/import.sql src/main/resources
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
jpa-new-field --named books --type org.sellingPoint.model.Book --relationship-type Many-to-Many --fetch-type EAGER
java-add-annotation --annotation org.hibernate.search.annotations.IndexedEmbedded --on-property books

rest-generate-endpoints-from-entities --targets org.sellingPoint.model.*
scaffold-generate --provider AngularJS --targets org.sellingPoint.model.*
wildfly-swarm-detect-fractions --depend --build
# enable CORS
rest-new-cross-origin-resource-sharing-filter

cd ~~
cd ..


#---------------- Update front end to consume Author and Books from new service
cp  frontend_assets/services/AuthorFactory.js bookstorefrontend/src/main/webapp/scripts/services/
cp  frontend_assets/services/BookFactory.js bookstorefrontend/src/main/webapp/scripts/services/

#---------------- Update front end to consume Selling points from new service
cp  frontend_assets/sellingpoint/search.html bookstorefrontend/src/main/webapp/views/SellingPoint
cp  frontend_assets/sellingpoint/searchSellingPointController.js bookstorefrontend/src/main/webapp/scripts/controllers
cp  frontend_assets/sellingpoint/SellingPointFactory.js bookstorefrontend/src/main/webapp/scripts/services


# ----------------  KeycloakServer [:8083/auth] ---------------
# create Keycloak Server service

project-new --named keycloakserver --stack JAVA_EE_7 --type wildfly-swarm --http-port 8083 --fractions keycloak-server

build
cd ~~
cd ..

