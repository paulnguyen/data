


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
    fk int not null
);

insert into setb (k, z1, z2, fk) 
values  (1, 'z1', 'z2', 2),
        (2, 'x1', 'x2', 2),
        (3, 'w1', 'w2', 3),
        (4, 'zz', 'ww', 5)
;



EXAMPLE:

mysql> use c9;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+--------------+
| Tables_in_c9 |
+--------------+
| seta         |
| setb         |
+--------------+
2 rows in set (0.00 sec)

mysql> 
mysql> drop table setb ;
Query OK, 0 rows affected (0.01 sec)

mysql> drop table seta ;
Query OK, 0 rows affected (0.00 sec)

mysql> 
mysql> create table seta ( 
    ->     k int not null primary key, 
    ->     a1 varchar(2), 
    ->     a2 varchar(3), 
    ->     a3 varchar(4)
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> 
mysql> insert into seta (k, a1, a2, a3) 
    -> values  (1, 'a', 'b', 'c'),
    ->         (2, 'd', 'e', 'f'),
    ->         (3, 'g', 'h', 'i'),
    ->         (4, 'j', 'k', 'l')
    -> ;
Query OK, 4 rows affected (0.00 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> 
mysql> create table setb (
    ->     k int not null primary key, 
    ->     z1 varchar(2), 
    ->     z2 varchar(3), 
    ->     fk int not null
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> 
mysql> insert into setb (k, z1, z2, fk) 
    -> values  (1, 'z1', 'z2', 2),
    ->         (2, 'x1', 'x2', 2),
    ->         (3, 'w1', 'w2', 3),
    ->         (4, 'zz', 'ww', 5)
    -> ;
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

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
| 4 | zz   | ww   |  5 |
+---+------+------+----+
4 rows in set (0.00 sec)


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
| NULL | NULL | NULL | NULL | 4 | zz   | ww   |  5 |
+------+------+------+------+---+------+------+----+
4 rows in set (0.00 sec)

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
| NULL | NULL | NULL | NULL | 4 | zz   | ww   |  5 |
+------+------+------+------+---+------+------+----+
4 rows in set (0.00 sec)


ALTER TABLE setb
ADD FOREIGN KEY (fk)
    REFERENCES seta(k) ;

mysql> ALTER TABLE setb
    -> ADD FOREIGN KEY (fk)
    ->     REFERENCES seta(k) ;
ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint 
fails (`c9`.`#sql-a6d_31`, CONSTRAINT `#sql-a6d_31_ibfk_1` 
FOREIGN KEY (`fk`) REFERENCES `seta` (`k`))


select * 
from seta LEFT OUTER JOIN setb 
ON setb.fk = seta.k 
UNION
select * 
from seta RIGHT JOIN setb 
ON setb.fk = seta.k ;

mysql> select * 
    -> from seta LEFT OUTER JOIN setb 
    -> ON setb.fk = seta.k 
    -> UNION
    -> select * 
    -> from seta RIGHT JOIN setb 
    -> ON setb.fk = seta.k ;
+------+------+------+------+------+------+------+------+
| k    | a1   | a2   | a3   | k    | z1   | z2   | fk   |
+------+------+------+------+------+------+------+------+
|    1 | a    | b    | c    | NULL | NULL | NULL | NULL |
|    2 | d    | e    | f    |    1 | z1   | z2   |    2 |
|    2 | d    | e    | f    |    2 | x1   | x2   |    2 |
|    3 | g    | h    | i    |    3 | w1   | w2   |    3 |
|    4 | j    | k    | l    | NULL | NULL | NULL | NULL |
| NULL | NULL | NULL | NULL |    4 | zz   | ww   |    5 |
+------+------+------+------+------+------+------+------+
6 rows in set (0.00 sec)

select * 
from seta LEFT OUTER JOIN setb 
ON setb.fk = seta.k 
UNION ALL
select * 
from seta RIGHT JOIN setb 
ON setb.fk = seta.k ;

mysql> select * 
    -> from seta LEFT OUTER JOIN setb 
    -> ON setb.fk = seta.k 
    -> UNION ALL
    -> select * 
    -> from seta RIGHT JOIN setb 
    -> ON setb.fk = seta.k ;
+------+------+------+------+------+------+------+------+
| k    | a1   | a2   | a3   | k    | z1   | z2   | fk   |
+------+------+------+------+------+------+------+------+
|    1 | a    | b    | c    | NULL | NULL | NULL | NULL |
|    2 | d    | e    | f    |    1 | z1   | z2   |    2 |
|    2 | d    | e    | f    |    2 | x1   | x2   |    2 |
|    3 | g    | h    | i    |    3 | w1   | w2   |    3 |
|    4 | j    | k    | l    | NULL | NULL | NULL | NULL |
|    2 | d    | e    | f    |    1 | z1   | z2   |    2 |
|    2 | d    | e    | f    |    2 | x1   | x2   |    2 |
|    3 | g    | h    | i    |    3 | w1   | w2   |    3 |
| NULL | NULL | NULL | NULL |    4 | zz   | ww   |    5 |
+------+------+------+------+------+------+------+------+
9 rows in set (0.00 sec)


select 'LEFT' label, seta.k, seta.a1, seta.a2, seta.a3, setb.k, setb.z1, setb.z2, setb.fk 
from seta LEFT OUTER JOIN setb 
ON setb.fk = seta.k 
UNION ALL
select 'RIGHT' label, seta.k, seta.a1, seta.a2, seta.a3, setb.k, setb.z1, setb.z2, setb.fk 
from seta RIGHT JOIN setb 
ON setb.fk = seta.k ;

mysql> select 'LEFT' label, seta.k, seta.a1, seta.a2, seta.a3, setb.k, setb.z1, setb.z2, setb.fk 
    -> from seta LEFT OUTER JOIN setb 
    -> ON setb.fk = seta.k 
    -> UNION ALL
    -> select 'RIGHT' label, seta.k, seta.a1, seta.a2, seta.a3, setb.k, setb.z1, setb.z2, setb.fk 
    -> from seta RIGHT JOIN setb 
    -> ON setb.fk = seta.k ;
+-------+------+------+------+------+------+------+------+------+
| label | k    | a1   | a2   | a3   | k    | z1   | z2   | fk   |
+-------+------+------+------+------+------+------+------+------+
| LEFT  |    1 | a    | b    | c    | NULL | NULL | NULL | NULL |
| LEFT  |    2 | d    | e    | f    |    1 | z1   | z2   |    2 |
| LEFT  |    2 | d    | e    | f    |    2 | x1   | x2   |    2 |
| LEFT  |    3 | g    | h    | i    |    3 | w1   | w2   |    3 |
| LEFT  |    4 | j    | k    | l    | NULL | NULL | NULL | NULL |
| RIGHT |    2 | d    | e    | f    |    1 | z1   | z2   |    2 |
| RIGHT |    2 | d    | e    | f    |    2 | x1   | x2   |    2 |
| RIGHT |    3 | g    | h    | i    |    3 | w1   | w2   |    3 |
| RIGHT | NULL | NULL | NULL | NULL |    4 | zz   | ww   |    5 |
+-------+------+------+------+------+------+------+------+------+
9 rows in set (0.02 sec)


select seta.k, seta.a1, seta.a2, seta.a3, setb.k, setb.z1, setb.z2, setb.fk 
from seta LEFT JOIN setb 
ON setb.fk = seta.k 
UNION 
select seta.k, seta.a1, seta.a2, seta.a3, setb.k, setb.z1, setb.z2, setb.fk 
from seta RIGHT JOIN setb 
ON setb.fk = seta.k ;

mysql> select seta.k, seta.a1, seta.a2, seta.a3, setb.k, setb.z1, setb.z2, setb.fk 
    -> from seta LEFT JOIN setb 
    -> ON setb.fk = seta.k 
    -> UNION 
    -> select seta.k, seta.a1, seta.a2, seta.a3, setb.k, setb.z1, setb.z2, setb.fk 
    -> from seta RIGHT JOIN setb 
    -> ON setb.fk = seta.k ;
+------+------+------+------+------+------+------+------+
| k    | a1   | a2   | a3   | k    | z1   | z2   | fk   |
+------+------+------+------+------+------+------+------+
|    1 | a    | b    | c    | NULL | NULL | NULL | NULL |
|    2 | d    | e    | f    |    1 | z1   | z2   |    2 |
|    2 | d    | e    | f    |    2 | x1   | x2   |    2 |
|    3 | g    | h    | i    |    3 | w1   | w2   |    3 |
|    4 | j    | k    | l    | NULL | NULL | NULL | NULL |
| NULL | NULL | NULL | NULL |    4 | zz   | ww   |    5 |
+------+------+------+------+------+------+------+------+
6 rows in set (0.00 sec)



