#!/usr/local/bin/php
<?php
spl_autoload_register(function ($class_name) {
	echo "Autoloading $class_name\r\n";
	$path= dirname(__FILE__) . "/" . str_replace("\\", "/", $class_name) . '.php';
	if (file_exists( $path ))
	{
		echo( "loading class $path\n" );
    		require_once $path;
	}
});
SueldosJugadores::getVersion();
?>
