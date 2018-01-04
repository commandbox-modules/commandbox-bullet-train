component {
	property name='shell' inject='shell';
	property name='semanticVersion'		inject='provider:semanticVersion@semver';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.boxVersionEnable ) { return; }
		
		var version = semanticVersion.parseVersion( shell.getVersion().replace( '@build.version@+@build.number@', '1.2.3+12345' ) );
		interceptData.cars.boxVersion.text = print.text( ' CLI v' & version.major & '.' & version.minor & '.' & version.revision & ' ', '#interceptData.settings.boxVersionText#on#interceptData.settings.boxVersionBG#' );
		
		interceptData.cars.boxVersion.background = interceptData.settings.boxVersionBG;
	}

}