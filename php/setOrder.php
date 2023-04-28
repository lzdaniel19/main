<?php

// Inport environment
require_once('../../common/php/environment.php');

// Get arguments
$args = Util::getArgs();

// Connect to database
$db = new Database();

// Set query
$query = 
"INSERT INTO `rendeles` ( `user_id`, `nev`, `szallitasicim`, `telefonszam`, 
                          `fizetesimod`, `megjegyzes`, `osszeg`, `datum`) 
VALUES (:user_id, :nev, :szallitasicim, :telefonszam, 
        :fizetesimod, :megjegyzes, :osszeg, :datum)";

// Execute query
$order = $db->execute($query, array(
  'user_id'       => $args['user_id'], 
  'nev'           => $args['nev'], 
  'szallitasicim' => $args['szallitasicim'], 
  'telefonszam'   => $args['telefonszam'], 
  'fizetesimod'   => $args['fizetesimod'], 
  'megjegyzes'    => $args['megjegyzes'], 
  'osszeg'        => $args['osszeg'], 
  'datum'         => date('Y-m-d H:i:s')
));

// Check result
if ($order['affectedRows'] !== 1)
  Util::setError("A rendelést nem sikerült rögzíteni!");

// Set query
$query = "INSERT INTO `rendelesi_tetel` (`rendeles_id`, `termek_id`, `ar`, `darab`, `osszeg`, `meret`) VALUES";

// Set parameters
$params = array();
foreach($args['items'] as $item) {
  $params = array_merge($params, 
            array_merge(array($order['lastInsertId']), 
            array_values($item)));
}

// Execute query
$result = $db->execute($query, $params);

// Disconnect
$db = null;

Util::setResponse($result);