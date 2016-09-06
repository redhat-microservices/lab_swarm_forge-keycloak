insert into Book (id, isbn, version) values (1000, '1000',0);
insert into Book (id, isbn, version) values (1001, '1001',0);
insert into Book (id, isbn, version) values (1002, '1002',0);

insert into SellingPoint (id, latitude, longitude, name, version) values (2000, 43.5780, 7.0545, 'bob', 0);
insert into SellingPoint (id, latitude, longitude, name, version) values (2001, 43.574357, 7.1142449, 'chris',0);

insert into SellingPoint_Book (SellingPoint_id, books_id) values (2000,1000);
insert into SellingPoint_Book (SellingPoint_id, books_id) values (2000,1001);
