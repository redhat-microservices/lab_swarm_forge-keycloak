# Create the project
project-new --named mylab --stack JAVA_EE_7 --type wildfly-swarm

# Create the JPA entity
jpa-new-entity --named Book

# Add fields to the Book entity
jpa-new-field --named title

# Create the REST endpoint for the entity

# Setup WildFly Swarm maven plugin
addon-install-from-git --url https://github.com/forge/wildfly-swarm-addon.git
addon-install-from-git --url https://github.com/forge/keycloak-addon.git

# Detect and add the missing fractions
wildfly-swarm-detect-fractions --build  --depend

# Configure KeyCloak authentication
wildfly-swarm-add-fraction --fractions keycloak
security-add-login-config --auth-method KEYCLOAK --security-realm master
security-add-constraint --web-resource-name Customer --url-patterns /rest/${the-entity} --security-roles user

# Install the keycloak.json file to WEB-INF
keycloak-install-client-json --server-url http://localhost:9000/auth --realm master --client-id security-admin-console --user admin --password admin
