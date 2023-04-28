<?php

// Inport environment
require_once('../../common/php/environment.php');

// Connect to database
$db = new Database();

// Set queries
$query['tipus']   = "SELECT DISTINCT `tipus`, `tipus_path` FROM `termekek` ORDER BY `tipus`";
$query['termek']  = "SELECT * FROM `termekek` ORDER BY `tipus`, `ar` DESC";

// Execute query
$result['tipus'] = $db->execute($query['tipus']);

// Execute query
$termekek = $db->execute($query['termek']);

// Disconnect
$db = null;

// Check valid
if (is_array($termekek) && count($termekek) > 0) {

  // Convert result
  foreach($termekek as $i => $termek) {
    $termekek[$i]['meret']  = array_filter(explode(",", $termek['meret']));
    $termekek[$i]['darab']  = 1;
    $termekek[$i]['total']  = $termek['ar'];
    $termekek[$i]['size']   = is_array($termekek[$i]['meret']) &&
                              count($termekek[$i]['meret']) > 0 ?
                              $termekek[$i]['meret'][0]: null;
  }
}

// Set result
$result["termek"] = $termekek;

Util::setResponse($result);