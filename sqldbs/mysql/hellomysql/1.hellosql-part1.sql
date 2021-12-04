

create table seta ( k int not null, a1 varchar(2), a2 varchar(3), a3 varchar(4), primary key(k));
insert into seta (k, a1, a2, a3) values (1, 'a', 'b', 'c');
insert into seta (k, a1, a2, a3) values (2, 'd', 'e', 'f');
insert into seta (k, a1, a2, a3) values (3, 'g', 'h', 'i');
insert into seta (k, a1, a2, a3) values (4, 'j', 'k', 'l');

create table setb (k int not null, z1 varchar(2), z2 varchar(3), fk int not null, primary key(k));
insert into setb (k, z1, z2, fk) values (1, 'z1', 'z2', 2);
insert into setb (k, z1, z2, fk) values (2, 'x1', 'x2', 2);
insert into setb (k, z1, z2, fk) values (3, 'w1', 'w2', 3);


EXAMPLE:

use c9 ;
Database changed

mysql> select * from seta ;
+---+------+------+------+
| k | a1   | a2   | a3   |
+---+------+------+------+
| 1 | a    | b    | c    |
| 2 | d    | e    | f    |
| 3 | g    | h    | i    |
| 4 | j    | k    | l    |
+---+------+------+------+
4 rows in set (0.00 sec)

mysql> select * from seta where k < 3 ;
+---+------+------+------+
| k | a1   | a2   | a3   |
+---+------+------+------+
| 1 | a    | b    | c    |
| 2 | d    | e    | f    |
+---+------+------+------+
2 rows in set (0.00 sec)


mysql> select * from seta where a3 = 'c'
    -> ;
+---+------+------+------+
| k | a1   | a2   | a3   |
+---+------+------+------+
| 1 | a    | b    | c    |
+---+------+------+------+
1 row in set (0.00 sec)

mysql> select a1, a2 from seta ;                                                                                
+------+------+
| a1   | a2   |
+------+------+
| a    | b    |
| d    | e    |
| g    | h    |
| j    | k    |
+------+------+
4 rows in set (0.00 sec)

mysql> select k, a1, a2, k+1 foo from seta ;                                                                    
+---+------+------+-----+
| k | a1   | a2   | foo |
+---+------+------+-----+
| 1 | a    | b    |   2 |
| 2 | d    | e    |   3 |
| 3 | g    | h    |   4 |
| 4 | j    | k    |   5 |
+---+------+------+-----+
4 rows in set (0.00 sec)

mysql> select k, a1, a2, a1+1 foo from seta ;                                                                   
+---+------+------+------+
| k | a1   | a2   | foo  |
+---+------+------+------+
| 1 | a    | b    |    1 |
| 2 | d    | e    |    1 |
| 3 | g    | h    |    1 |
| 4 | j    | k    |    1 |
+---+------+------+------+
4 rows in set, 4 warnings (0.00 sec)

mysql> select k, a1, a2, ascii(a1)+1 foo from seta ;                                                            
+---+------+------+------+
| k | a1   | a2   | foo  |
+---+------+------+------+
| 1 | a    | b    |   98 |
| 2 | d    | e    |  101 |
| 3 | g    | h    |  104 |
| 4 | j    | k    |  107 |
+---+------+------+------+
4 rows in set (0.00 sec)

mysql> select * from seta, setb;
+---+------+------+------+---+------+------+----+
| k | a1   | a2   | a3   | k | z1   | z2   | fk |
+---+------+------+------+---+------+------+----+
| 1 | a    | b    | c    | 1 | z1   | z2   |  2 |
| 1 | a    | b    | c    | 2 | x1   | x2   |  2 |
| 1 | a    | b    | c    | 3 | w1   | w2   |  3 |
| 2 | d    | e    | f    | 1 | z1   | z2   |  2 |
| 2 | d    | e    | f    | 2 | x1   | x2   |  2 |
| 2 | d    | e    | f    | 3 | w1   | w2   |  3 |
| 3 | g    | h    | i    | 1 | z1   | z2   |  2 |
| 3 | g    | h    | i    | 2 | x1   | x2   |  2 |
| 3 | g    | h    | i    | 3 | w1   | w2   |  3 |
| 4 | j    | k    | l    | 1 | z1   | z2   |  2 |
| 4 | j    | k    | l    | 2 | x1   | x2   |  2 |
| 4 | j    | k    | l    | 3 | w1   | w2   |  3 |
+---+------+------+------+---+------+------+----+
12 rows in set (0.00 sec)

mysql> select * from seta, setb where setb.fk = seta.k ;
+---+------+------+------+---+------+------+----+
| k | a1   | a2   | a3   | k | z1   | z2   | fk |
+---+------+------+------+---+------+------+----+
| 2 | d    | e    | f    | 1 | z1   | z2   |  2 |
| 2 | d    | e    | f    | 2 | x1   | x2   |  2 |
| 3 | g    | h    | i    | 3 | w1   | w2   |  3 |
+---+------+------+------+---+------+------+----+
3 rows in set (0.00 sec)

mysql> select a.a1, b.z1 from seta a, setb b where b.fk = a.k ;                                                 
+------+------+
| a1   | z1   |
+------+------+
| d    | z1   |
| d    | x1   |
| g    | w1   |
+------+------+
3 rows in set (0.00 sec)

mysql> 