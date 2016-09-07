angular.module('bookservice').factory('SellingPointResource', function($resource){
    var resource = $resource('http://localhost:8082/rest/sellingpoints/inrange/:Isbn',{Isbn:'@isbn'},{'queryAll':{method:'GET',isArray:true},'query':{method:'GET',isArray:false},'update':{method:'PUT'}});
    return resource;
});
