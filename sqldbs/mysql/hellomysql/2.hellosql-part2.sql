
drop table setb ;
drop table seta ;

create table seta ( 
    k int not null primary key, 
    a1 varchar(2), 
    a2 varchar(3), 
    a3 varchar(4)
);

insert into seta (k, a1, a2, a3) 
values  (1, 'a', 'b', 'c'),
        (2, 'd', 'e', 'f'),
        (3, 'g', 'h', 'i'),
        (4, 'j', 'k', 'l')
;

create table setb (
    k int not null primary key, 
    z1 varchar(2), 
    z2 varchar(3), 
    fk int not null,
    CONSTRAINT fk_seta FOREIGN KEY (fk)
    REFERENCES seta(k)
);

insert into setb (k, z1, z2, fk) 
values  (1, 'z1', 'z2', 2),
        (2, 'x1', 'x2', 2),
        (3, 'w1', 'w2', 3)
;



EXAMPLE:

mysql> use c9
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> drop table setb ;
Query OK, 0 rows affected (0.03 sec)

mysql> drop table seta ;
Query OK, 0 rows affected (0.01 sec)

mysql> create table seta ( 
    ->     k int not null primary key, 
    ->     a1 varchar(2), 
    ->     a2 varchar(3), 
    ->     a3 varchar(4)
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql> create table setb (
    ->     k int not null primary key, 
    ->     z1 varchar(2), 
    ->     z2 varchar(3), 
    ->     fk int not null,
    ->     CONSTRAINT fk_seta FOREIGN KEY (fk)
    ->     REFERENCES seta(k)
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> insert into seta (k, a1, a2, a3) 
    -> values  (1, 'a', 'b', 'c'),
    ->         (2, 'd', 'e', 'f'),
    ->         (3, 'g', 'h', 'i'),
    ->         (4, 'j', 'k', 'l')
    -> ;
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> insert into setb (k, z1, z2, fk) 
    -> values  (1, 'z1', 'z2', 2),
    ->         (2, 'x1', 'x2', 2),
    ->         (3, 'w1', 'w2', 3)
    -> ;
Query OK, 3 rows affected (0.01 sec)
Records: 3  Duplicates: 0  Warnings: 0

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

mysql> select * from setb ;
+---+------+------+----+
| k | z1   | z2   | fk |
+---+------+------+----+
| 1 | z1   | z2   |  2 |
| 2 | x1   | x2   |  2 |
| 3 | w1   | w2   |  3 |
+---+------+------+----+
3 rows in set (0.00 sec)

mysql> select * from seta, setb ;
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
12 rows in set (0.01 sec)

mysql> select * from seta, setb where setb.fk = seta.k ;
+---+------+------+------+---+------+------+----+
| k | a1   | a2   | a3   | k | z1   | z2   | fk |
+---+------+------+------+---+------+------+----+
| 2 | d    | e    | f    | 1 | z1   | z2   |  2 |
| 2 | d    | e    | f    | 2 | x1   | x2   |  2 |
| 3 | g    | h    | i    | 3 | w1   | w2   |  3 |
+---+------+------+------+---+------+------+----+
3 rows in set (0.01 sec)


select * 
from seta INNER JOIN setb 
ON setb.fk = seta.k ;

mysql> select * 
    -> from seta INNER JOIN setb 
    -> ON setb.fk = seta.k ;
+---+------+------+------+---+------+------+----+
| k | a1   | a2   | a3   | k | z1   | z2   | fk |
+---+------+------+------+---+------+------+----+
| 2 | d    | e    | f    | 1 | z1   | z2   |  2 |
| 2 | d    | e    | f    | 2 | x1   | x2   |  2 |
| 3 | g    | h    | i    | 3 | w1   | w2   |  3 |
+---+------+------+------+---+------+------+----+
3 rows in set (0.01 sec)

select * 
from seta JOIN setb 
ON setb.fk = seta.k ;

mysql> select * 
    -> from seta JOIN setb 
    -> ON setb.fk = seta.k ;
+---+------+------+------+---+------+------+----+
| k | a1   | a2   | a3   | k | z1   | z2   | fk |
+---+------+------+------+---+------+------+----+
| 2 | d    | e    | f    | 1 | z1   | z2   |  2 |
| 2 | d    | e    | f    | 2 | x1   | x2   |  2 |
| 3 | g    | h    | i    | 3 | w1   | w2   |  3 |
+---+------+------+------+---+------+------+----+
3 rows in set (0.00 sec)

select * 
from seta LEFT OUTER JOIN setb 
ON setb.fk = seta.k ;

mysql> select * 
    -> from seta LEFT OUTER JOIN setb 
    -> ON setb.fk = seta.k ;
+---+------+------+------+------+------+------+------+
| k | a1   | a2   | a3   | k    | z1   | z2   | fk   |
+---+------+------+------+------+------+------+------+
| 1 | a    | b    | c    | NULL | NULL | NULL | NULL |
| 2 | d    | e    | f    |    1 | z1   | z2   |    2 |
| 2 | d    | e    | f    |    2 | x1   | x2   |    2 |
| 3 | g    | h    | i    |    3 | w1   | w2   |    3 |
| 4 | j    | k    | l    | NULL | NULL | NULL | NULL |
+---+------+------+------+------+------+------+------+
5 rows in set (0.00 sec)

select * 
from seta LEFT JOIN setb 
ON setb.fk = seta.k ;

mysql> select * 
    -> from seta LEFT JOIN setb 
    -> ON setb.fk = seta.k ;
+---+------+------+------+------+------+------+------+
| k | a1   | a2   | a3   | k    | z1   | z2   | fk   |
+---+------+------+------+------+------+------+------+
| 1 | a    | b    | c    | NULL | NULL | NULL | NULL |
| 2 | d    | e    | f    |    1 | z1   | z2   |    2 |
| 2 | d    | e    | f    |    2 | x1   | x2   |    2 |
| 3 | g    | h    | i    |    3 | w1   | w2   |    3 |
| 4 | j    | k    | l    | NULL | NULL | NULL | NULL |
+---+------+------+------+------+------+------+------+
5 rows in set (0.00 sec)

select * 
from seta RIGHT OUTER JOIN setb 
ON setb.fk = seta.k ;

mysql> select * 
    -> from seta RIGHT OUTER JOIN setb 
    -> ON setb.fk = seta.k ;
+------+------+------+------+---+------+------+----+
| k    | a1   | a2   | a3   | k | z1   | z2   | fk |
+------+------+------+------+---+------+------+----+
|    2 | d    | e    | f    | 1 | z1   | z2   |  2 |
|    2 | d    | e    | f    | 2 | x1   | x2   |  2 |
|    3 | g    | h    | i    | 3 | w1   | w2   |  3 |
+------+------+------+------+---+------+------+----+
3 rows in set (0.00 sec)

select * 
from seta RIGHT JOIN setb 
ON setb.fk = seta.k ;

mysql> select * 
    -> from seta RIGHT JOIN setb 
    -> ON setb.fk = seta.k ;
+------+------+------+------+---+------+------+----+
| k    | a1   | a2   | a3   | k | z1   | z2   | fk |
+------+------+------+------+---+------+------+----+
|    2 | d    | e    | f    | 1 | z1   | z2   |  2 |
|    2 | d    | e    | f    | 2 | x1   | x2   |  2 |
|    3 | g    | h    | i    | 3 | w1   | w2   |  3 |
+------+------+------+------+---+------+------+----+
3 rows in set (0.00 sec)

select * 
from seta FULL OUTER JOIN setb 
ON setb.fk = seta.k ;

mysql> select * 
    -> from seta FULL OUTER JOIN setb 
    -> ON setb.fk = seta.k ;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'OUTER JOIN setb 
ON setb.fk = seta.k' at line 2






