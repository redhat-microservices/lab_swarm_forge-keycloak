'use strict';

angular.module('bookservice',['ngRoute','ngResource'])
  .config(['$routeProvider', function($routeProvider) {
    $routeProvider
      .when('/',{templateUrl:'views/landing.html',controller:'LandingPageController'})
      .when('/Authors',{templateUrl:'views/Author/search.html',controller:'SearchAuthorController'})
      .when('/Authors/new',{templateUrl:'views/Author/detail.html',controller:'NewAuthorController'})
      .when('/Authors/edit/:AuthorId',{templateUrl:'views/Author/detail.html',controller:'EditAuthorController'})
      .when('/Books',{templateUrl:'views/Book/search.html',controller:'SearchBookController'})
      .when('/Books/new',{templateUrl:'views/Book/detail.html',controller:'NewBookController'})
      .when('/Books/edit/:BookId',{templateUrl:'views/Book/detail.html',controller:'EditBookController'})
      .when('/SellingPoints',{templateUrl:'views/SellingPoint/search.html',controller:'SearchSellingPointController'})
      .when('/SellingPoints/new',{templateUrl:'views/SellingPoint/detail.html',controller:'NewSellingPointController'})
      .when('/SellingPoints/edit/:SellingPointId',{templateUrl:'views/SellingPoint/detail.html',controller:'EditSellingPointController'})
      .otherwise({
        redirectTo: '/'
      });
  }])
  .controller('LandingPageController', function LandingPageController() {
  })
  .controller('NavController', function NavController($scope, $location) {
    $scope.matchesRoute = function(route) {
        var path = $location.path();
        return (path === ("/" + route) || path.indexOf("/" + route + "/") == 0);
    };
  });

var keycloak = new Keycloak('keycloak.json');

angular.element(document).ready(function() {
  keycloak.init({ onLoad: 'login-required' }).success(function () {
    angular.bootstrap(document, ["myapp"]);
  }).error(function () {
    console.log("ERROR");
  });
});


angular.module('bookservice').factory('authInterceptor', function($q) {
  return {
    request: function (config) {
      var deferred = $q.defer();
      if (keycloak.token) {
        keycloak.updateToken(5).success(function() {
          config.headers = config.headers || {};
          config.headers.Authorization = 'Bearer ' + keycloak.token;
          deferred.resolve(config);
        }).error(function() {
          deferred.reject('Failed to refresh token');
        });
      }
      return deferred.promise;
    }
  };
});

angular.module('bookservice').config(function($httpProvider) {
  $httpProvider.defaults.useXDomain = true;
  $httpProvider.interceptors.push('authInterceptor');
});