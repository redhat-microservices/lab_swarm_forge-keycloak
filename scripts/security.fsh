# security steps , make sure a kc server  is running and that the demo realm has been importet (holrealm.json)

# secure the bookService

cp bookservice_assets/keycloak.json bookservice/src/main/webapp/WEB-INF
cd bookservice
wildfly-swarm-add-fraction --fractions keycloak
security-add-login-config --auth-method KEYCLOAK --security-realm master
security-add-constraint --web-resource-name Book --url-patterns /rest --security-roles user
rm src/main/java/org/bookservice/rest/NewCrossOriginResourceSharingFilter.java

# redeploy and make sure the endpoint is protected by accessing directly its URL (i.e : localhost:8080/rest/books should show unauthorized)


cd ~~/..

# Secure the frontend
cp  frontend_assets/keycloak.json bookstorefrontend/src/main/webapp
cp  frontend_assets/keycloak.js bookstorefrontend/src/main/webapp/scripts/vendor
cp  frontend_assets/app.js bookstorefrontend/src/main/webapp/scripts
cp  frontend_assets/app.html bookstorefrontend/src/main/webapp
cd bookstorefrontend

# Redeploy the frontend, it should now redirect to the keycloak login screen

cd ~~/..

# secure the sellingPoint

cp sellingpoint_assets/keycloak.json sellingpoint/src/main/webapp/WEB-INF
cd sellingpoint
wildfly-swarm-add-fraction --fractions keycloak
security-add-login-config --auth-method KEYCLOAK --security-realm master
security-add-constraint --web-resource-name SellingPoint --url-patterns /rest --security-roles user
rm src/main/java/org/sellingPoint/rest/NewCrossOriginResourceSharingFilter.java

# SellingPoint is now secured.







