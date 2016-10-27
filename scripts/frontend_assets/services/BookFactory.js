angular.module('bookservice').factory('BookResource', function($resource){
    var resource = $resource('http://localhost:8080/rest/books/:BookId',{BookId:'@id'},{'queryAll':{method:'GET',isArray:true},'query':{method:'GET',isArray:false},'update':{method:'PUT'}});
    return resource;
});
