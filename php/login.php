<?php

// Inport environment
require_once('../../common/php/environment.php');

// Get arguments
$args = Util::getArgs();

// Connect to database
$db = new Database();

// Set query
$query = 
"SELECT `id`, `nev`, `lakcim`, `telefonszam`
FROM `felhasznalok` 
WHERE `email` = :email AND BINARY `jelszo` = BINARY :jelszo 
LIMIT 1";

// Execute query
$result = $db->execute($query, $args);

// Check result
if (is_null($result))
  Util::setError("Hibás felhasználó, vagy jelszó!");

// Set result
$result = $result[0];

// Disconnect
$db = null;

Util::setResponse($result);