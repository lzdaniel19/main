<?php

// Inport environment
require_once('../../common/php/environment.php');

// Get arguments
$args = Util::getArgs();
unset($args['jelszo2']);

// Connect to database
$db = new Database();

// Set query
$query = "
SELECT `id` 
FROM `felhasznalok` 
WHERE `email` = :email 
LIMIT 1";

// Execute query
$result = $db->execute($query, array('email'=>$args['email']));

// Check result
if (!is_null($result))
	Util::setError("Az email cím már létezik!");

// Set query
$query = 
"INSERT INTO `felhasznalok`(`email`, `jelszo`, `nev`, `lakcim`, `telefonszam`) 
VALUES (:email, :jelszo, :nev, :lakcim, :telefonszam)";

// Execute query
$result = $db->execute($query, $args);

// Disconnect
$db = null;

Util::setResponse($result);