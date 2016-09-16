minishift delete
minishift start --vm-driver=xhyve --memory=4048 --deploy-registry=true --deploy-router=true
oc login $(minishift ip):8443 -u=admin -p=admin

echo "Create a new project for ci/cd"
oc new-project ci-cd

echo "Add the templates containing the Openshift examples (Ruby, PHP, ...) & Jenkins"
oc create -f https://raw.githubusercontent.com/openshift/origin/master/examples/image-streams/image-streams-centos7.json -n openshift
oc create -f https://raw.githubusercontent.com/openshift/origin/master/examples/jenkins/jenkins-ephemeral-template.json -n openshift

echo "Deploy Jenkins (without persistence)"
oc new-app jenkins-ephemeral

--> Deploying template "jenkins-ephemeral" in project "openshift"

     jenkins-ephemeral
     ---------
     Jenkins service, without persistent storage.
WARNING: Any data stored will be lost upon pod destruction. Only use this template for testing

     A Jenkins service has been created in your project.  The username/password are admin/do74BWFgyEdyna1r.  The tutorial at https://github.com/openshift/origin/blob/master/examples/jenkins/README.md contains more information about using this template.

     * With parameters:
        * Jenkins Service Name=jenkins
        * Jenkins JNLP Service Name=jenkins-jnlp
        * Jenkins Password=do74BWFgyEdyna1r # generated
        * Memory Limit=512Mi
        * Jenkins ImageStream Namespace=openshift
        * Jenkins ImageStreamTag=jenkins:latest

--> Creating resources with label app=jenkins-ephemeral ...
    route "jenkins" created
    deploymentconfig "jenkins" created
    serviceaccount "jenkins" created
    rolebinding "jenkins_edit" created
    service "jenkins-jnlp" created
    service "jenkins" created
--> Success
    Run 'oc status' to view your app.

echo "Create a new application containing a Jenkins Pipeline"
oc new-app -f https://raw.githubusercontent.com/openshift/origin/master/examples/jenkins/pipeline/samplepipeline.json
--> Deploying template jenkins-pipeline-example for "https://raw.githubusercontent.com/openshift/origin/master/examples/jenkins/pipeline/samplepipeline.json"

     jenkins-pipeline-example
     ---------
     This example showcases the new Jenkins Pipeline integration in OpenShift, which performs continuous integration and deployment right on the platform. The template contains a Jenkinsfile - a definition of a multi-stage CI process - that leverages the underlying OpenShift platform for dynamic and scalable builds. OpenShift integrates the status of your pipeline builds into the web console allowing you to see your entire application lifecycle in a single view.

     The Jenkins server is not currently automatically instantiated for you.  Please instantiate one of the Jenkins templates to create a Jenkins server for managing your pipeline build configurations.

     * With parameters:
        * ADMIN_USERNAME=admin11K # generated
        * ADMIN_PASSWORD=xeSuFO0f # generated
        * MYSQL_USER=userB7J # generated
        * MYSQL_PASSWORD=WNJL2IXJ # generated
        * MYSQL_DATABASE=root

--> Creating resources with label app=jenkins-pipeline-example ...
    buildconfig "sample-pipeline" created
    service "frontend" created
    route "frontend" created
    imagestream "origin-ruby-sample" created
    buildconfig "ruby-sample-build" created
    deploymentconfig "frontend" created
    service "database" created
    deploymentconfig "database" created
--> Success
    Use 'oc start-build sample-pipeline' to start a build.
    Use 'oc start-build ruby-sample-build' to start a build.
    Run 'oc status' to view your app.

echo "Start the build defined as Jenkins Job"
oc start-build sample-pipeline

echo "Next you should be able to access the Ruby Sample application after a few minutes"

https://frontend-ci-cd.192.168.64.13.xip.io/
