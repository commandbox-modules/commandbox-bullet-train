component {
	property name='packageService' inject='packageService';
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		
		if( !interceptData.settings.packageEnable ) { return; }
		
		var CWD = fileSystem.resolvePath( '' );
		if( packageService.isPackage( CWD ) ) {
			var boxJSON = packageService.readPackageDescriptor( CWD );
			interceptData.cars.package.text = print.boldWhiteOnmagenta( ' ' & boxJSON.name & ' (' & boxJSON.version & ') ', '#interceptData.settings.packageText#on#interceptData.settings.packageBG#' );
		
			interceptData.cars.package.background = interceptData.settings.packageBG;
		}
	}

}