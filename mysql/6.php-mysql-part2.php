<?php

    function getDB()
    {
        $dbhost = "127.0.0.1";
        $dbuser = "paulnguyen";                       // Your Cloud 9 username
        $dbpass = "";                                 // Remember, there is NO password by default!
        $dbname = "c9";                               // Your database name you want to connect to
        $dbport = 3306;                               // The port #. It is always 3306
 
        $mysql_conn_string = "mysql:host=$dbhost;dbname=$dbname;port=$dbport";
        $dbConnection = new PDO($mysql_conn_string, $dbuser, $dbpass); 
        $dbConnection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $dbConnection;
    }

    $db = getDB(); 
    foreach ($db->query("SELECT * FROM seta, setb") as $row) {
        echo $row['k'] . "|" . $row['a1'] . "|" . $row['z1'] . "<br/>" ;
    }
    $db = null ;

?>