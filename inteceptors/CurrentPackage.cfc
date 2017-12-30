component {
	property name='packageService' inject='packageService';
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		var CWD = fileSystem.resolvePath( '' );
		if( packageService.isPackage( CWD ) ) {
			var boxJSON = packageService.readPackageDescriptor( CWD );
			interceptData.currentPackage = print.boldWhiteOnmagenta( ' ' & boxJSON.name & ' (' & boxJSON.version & ') >' );
		}
	}

}