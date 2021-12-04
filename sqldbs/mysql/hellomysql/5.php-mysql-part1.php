<?php

    // Connect to the database
    // REF:  https://docs.c9.io/docs/connecting-php-to-mysql
    
    $host = "127.0.0.1";
    $user = "paulnguyen";                       // Your Cloud 9 username
    $pass = "";                                 // Remember, there is NO password by default!
    $db = "c9";                                 // Your database name you want to connect to
    $port = 3306;                               // The port #. It is always 3306

    $connection = mysqli_connect($host, $user, $pass, $db, $port)or die(mysql_error());

    //And now to perform a simple query to make sure it's working
    $query = "SELECT * FROM seta";
    $result = mysqli_query($connection, $query);

    while ($row = mysqli_fetch_assoc($result)) {
        echo "k: " . $row['k'] . " a1: " . $row['a1'] . " a2: " . $row['a2'] . " a3: " . $row['a3'] . "<br/>" ;
    }

?>