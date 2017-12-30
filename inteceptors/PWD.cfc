component {
	property name='fileSystem' inject='fileSystem';
	property name='print' inject='print';

	function onBulletTrain( interceptData ) {
		interceptData.pwd = print.boldWhiteOnBlue( ' ' & fileSystem.resolvePath( '' ).listLast( '\/' ) & '/ >' );
	}

}