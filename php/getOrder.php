<?php

// Inport environment
require_once('../../common/php/environment.php');

// Get arguments
$args = Util::getArgs();

// Connect to database
$db = new Database();

// Set query
$query = "SELECT * 
					FROM `rendeles` 
					WHERE `user_id` = :user
					ORDER BY `id` DESC;";

// Execute query
$result = $db->execute($query, array(
	'user' => intval($args))
);

// Check result
if (is_array($result) && count($result) > 0) {

	// Each order
	foreach($result as $i => $item) {

		// Set query
		$query = "SELECT 	`tetel`.`rendeles_id`, 
											`tetel`.`termek_id`, 
											`tetel`.`ar`, 
											`tetel`.`darab`, 
											`tetel`.`osszeg`, 
											`tetel`.`meret`,
											`termekek`.`megnevezes`,
											`termekek`.`tipus`,
											`termekek`.`tipus_path`,
											`termekek`.`url_id`,
											`termekek`.`leiras`,
											`termekek`.`kep`
							FROM `rendelesi_tetel` `tetel`
							INNER JOIN `termekek`
							ON `tetel`.`termek_id` = `termekek`.`termek_id`
							WHERE `tetel`.`rendeles_id` = :rendeles
							ORDER BY `tetel`.`id`";

		// Execute query
		$result[$i]['items'] = $db->execute($query, array(
			'rendeles' => intval($item['id']))
		);
	}
}

// Disconnect
$db = null;

Util::setResponse($result);