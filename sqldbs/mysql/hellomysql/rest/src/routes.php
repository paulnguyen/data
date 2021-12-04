<?php

 use Slim\App;

// DB Helper

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

// Routes

$app->get('/hello', function ($req, $res, $args) {
    
    $body = $res->getBody();
    $body->write('<h1>Hello Slim!</h1>');    

    return $res->withHeader(
        'Content-Type',
        'text/html'
    );
});

$app->get('/seta/{id}', function ($req, $res, $args) {

    try 
    {
        $db = getDB();
        $sql = $db->prepare("SELECT * FROM seta WHERE k = :id") ;
 
        $sql->bindParam(':id', $args['id'], PDO::PARAM_INT);
        $sql->execute();
 
        $rec = $sql->fetch(PDO::FETCH_OBJ);
 
        if($rec) {
            $res->withStatus(200);
            $res->withHeader('Content-Type', 'application/json');
            $body = $res->getBody();
            $body->write( json_encode($rec) );   
            $db = null;
        } else {
            throw new PDOException('No records found.');
        }
 
    } catch(PDOException $e) {
        $res->withStatus(404);
        $res->withHeader('Content-Type', 'application/json');
        $body = $res->getBody();
        $body->write( '{"error":{"text":'. $e->getMessage() .'}}' );   
    }
});


$app->get('/join', function ($req, $res, $args) {

    try 
    {
        $db = getDB();
        $res->withStatus(200);
        $res->withHeader('Content-Type', 'application/json');
        $body = $res->getBody();
        
        $arr = [ ] ;
        foreach ($db->query("SELECT * FROM seta, setb") as $row) {
            $arr[ $row['k'] ] = json_encode($row) ;
        }
        $body->write( json_encode($arr) );  
        $db = null ;
        
    } catch(PDOException $e) {
        $res->withStatus(404);
        $res->withHeader('Content-Type', 'application/json');
        $body = $res->getBody();
        $body->write( '{"error":{"text":'. $e->getMessage() .'}}' );   
    }
});


$app->get('/', function ($req, $res, $args) {
    $res->withStatus(200);
    $body = $res->getBody();
    $body->write("Welcome to Slim based API");    
});