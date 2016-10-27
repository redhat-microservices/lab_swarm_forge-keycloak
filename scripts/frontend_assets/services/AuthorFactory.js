angular.module('bookservice').factory('AuthorResource', function($resource){
    var resource = $resource('http://localhost:8080/rest/authors/:AuthorId',{AuthorId:'@id'},{'queryAll':{method:'GET',isArray:true},'query':{method:'GET',isArray:false},'update':{method:'PUT'}});
    return resource;
});
